// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at https://github.com/adamjcook/statechart.dart/blob/master/LICENSE
// The complete set of contributors may be found at https://github.com/adamjcook/statechart.dart/blob/master/CONTRIBUTORS

/**
 * A library for constructing and working with Harel statecharts.
 *
 * TODO(adamjcook): Add a brief description of functionality and use here.
 */
library statechart.client;

import 'dart:async';
import 'dart:math';

import 'package:logging/logging.dart';

import 'url_matcher.dart';
export 'url_matcher.dart';
import 'url_template.dart';

part 'state_handle.dart';

final Logger _logger = new Logger('statechart');

typedef void StatePreEnterEventHandler(StatePreEnterEvent event);
typedef void StateEnterEventHandler(StateEnterEvent event);
typedef void StatePreLeaveEventHandler(StatePreLeaveEvent event);
typedef void StateLeaveEventHandler(StateLeaveEvent event);

/**
 * [State] represents a node in the state tree.
 */
abstract class State {
  /**
   * Returns a string which represents the name of this state.
   */
  String get name;

  /**
   * Source string for the path regular expression.
   */
  // TODO(adamjcook): Maybe not the most efficient way of getting source string?
  String get sourcePath;

  /**
   * Returns an [URLMatcher] path match object based on the name for this state.
   */
  UrlMatcher get path;

  /**
   * Returns a [State] for the parent state of this state.
   */
  State get parent;

  /**
   * Creates and returns a new [StateHandle] for this state.
   */
  StateHandle newHandle();

  /**
   * Returns a boolean which indicates whether this state is currently active.
   */
  bool get isActive;

  /**
   * Returns a stream of [StatePreEnterEvent] events.
   * The [StatePreEnterEvent] event is fired when the state IS matched during the routing phase, but BEFORE
   * any states are actually left or any new states are entered.
   *
   * At this stage, it is possible to prevent the ENTERING of the state by calling [StatePreEnterEvent.allowLeave]
   * with a [Future] which returns a boolean value indicating whether the enter is permitted (true) or is not
   * permitted (false).
   */
  Stream<StatePreEnterEvent> get onPreEnter;

  /**
   * Returns a stream of [StatePreLeaveEvent] events.
   * The [StatePreLeaveEvent] event is fired when the state is NOT matched during the routing phase, but BEFORE
   * any states are actually left or any new states are entered.
   *
   * At this stage, it is possible to prevent the LEAVING of the state by calling [StatePreLeaveEvent.allowLeave]
   * with a [Future] which returns a boolean value indicating whether the leave is permitted (true) or is not
   * permitted (false).
   */
  Stream<StatePreLeaveEvent> get onPreLeave;

  /**
   * Returns a stream of [StateEnterEvent] events.
   * The [StateEnterEvent] event is fired when the state has already been made active,
   * but BEFORE any substates are entered. The event starts at the pivot node and propagates
   * from parent to child routes.
   */
  Stream<StateEnterEvent> get onEnter;

  /**
   * Returns a stream of [StateLeaveEvent] events.
   * The [StateLeaveEvent] event is fired when the state is being left. The event starts at the leaf
   * state and propagates from the child states to parent states.
   *
   * At this stage, it is possible to prevent the leaving of the state by calling [StateLeaveEvent.allowLeave]
   * with a [Future] which returns a boolean value indicating whether the leave is permitted (true) or is not
   * permitted (false). This is also known as a 'guard condition'.
   */
  Stream<StateLeaveEvent> get onLeave;

  void addState({
                String name,
                String sourcePath,
                Pattern path,
                StateEnterEventHandler enter,
                StatePreEnterEventHandler preEnter,
                StatePreLeaveEventHandler preLeave,
                StateLeaveEventHandler leave,
                mount});

  String toString() => '[State: $name, Parent: $parent, Source Path: $sourcePath, isActive: $isActive]';
}


/**
 * State is a node in the tree of states. The edge leading to the state is defined by the path.
 */
class StateImpl extends State {
  @override
  final String name;
  @override
  final String sourcePath;
  @override
  final UrlMatcher path;
  @override
  final StateImpl parent;

  final _states = <String, StateImpl>{};
  final StreamController<StateEnterEvent> _onEnterController;
  final StreamController<StatePreEnterEvent> _onPreEnterController;
  final StreamController<StatePreLeaveEvent> _onPreLeaveController;
  final StreamController<StateLeaveEvent> _onLeaveController;
  StateImpl _currentState;
  StateEvent _lastEvent;

  @override
  Stream<StateEvent> get onPreEnter => _onPreEnterController.stream;
  @override
  Stream<StateEvent> get onPreLeave => _onPreLeaveController.stream;
  @override
  Stream<StateEvent> get onLeave => _onLeaveController.stream;
  @override
  Stream<StateEvent> get onEnter => _onEnterController.stream;


  StateImpl._new({this.name, this.sourcePath, this.path, this.parent})
  : _onEnterController = new StreamController<StateEnterEvent>.broadcast(sync: true),
  _onPreEnterController = new StreamController<StatePreEnterEvent>.broadcast(sync: true),
  _onPreLeaveController = new StreamController<StatePreLeaveEvent>.broadcast(sync: true),
  _onLeaveController = new StreamController<StateLeaveEvent>.broadcast(sync: true);

  @override
  void addState({
                String name,
                String sourcePath,
                Pattern path,
                StateEnterEventHandler enter,
                StatePreEnterEventHandler preEnter,
                StatePreLeaveEventHandler preLeave,
                StateLeaveEventHandler leave,
                mount}) {
    if (name == null) {
      throw new ArgumentError('name is required for all states.');
    }

    if (path != null || sourcePath != null) {
      throw new ArgumentError('path and sourcePath cannot be specified at instantiation. These are generated by name.');
    } else if (path == null && sourcePath == null) {
      sourcePath = path = '/' + name;
    }

    if (_states.containsKey(name)) {
      throw new ArgumentError('State $name already exists.');
    }

    var matcher = path is UrlMatcher ? path : new UrlTemplate(path.toString());

    var state = new StateImpl._new(
        name: name,
        sourcePath: sourcePath,
        path: matcher,
        parent: this);

    state
      ..onPreEnter.listen(preEnter)
      ..onPreLeave.listen(preLeave)
      ..onEnter.listen(enter)
      ..onLeave.listen(leave);

    if (mount != null) {
      if (mount is Function) {
        mount(state);
      }
    }

    _states[name] = state;

    _logger.finest('state $state');
  }

  /**
   * Create and return a new [StateHandle] for this route.
   */
  @override
  StateHandle newHandle() {
    _logger.finest('newHandle for $this');
    return new StateHandle._new(this);
  }

  /**
   * Indicates whether this state is currently active. Only leaf states can be active.
   */
  @override
  bool get isActive =>
  parent == null ? true : identical(parent._currentState, this);
}


/**
 * [StateEvent] represents a state enter or leave event.
 */
abstract class StateEvent {
  final String path;
  final State state;

  StateEvent(this.path, this.state);
}


class StatePreEnterEvent extends StateEvent {
  final _allowEnterFutures = <Future<bool>>[];

  StatePreEnterEvent(path, state) : super(path, state);

  // TODO(adamjcook): m.urlMatch.match is probably not valid...was m.urlMatch.tail
  StatePreEnterEvent._fromMatch(_Match m) : this(m.urlMatch.match, m.state);

  void allowEnter(Future<bool> allow) {
    _allowEnterFutures.add(allow);
  }
}


class StateEnterEvent extends StateEvent {
  StateEnterEvent(path, state) : super(path, state);

  StateEnterEvent._fromMatch(_Match m) : this(m.urlMatch.match, m.state);
}


class StateLeaveEvent extends StateEvent {
  StateLeaveEvent(path, state) : super(path, state);

  StateLeaveEvent _clone() => new StateLeaveEvent(path, state);
}


class StatePreLeaveEvent extends StateEvent {
  final _allowLeaveFutures = <Future<bool>>[];

  StatePreLeaveEvent(path, state) : super(path, state);

  void allowLeave(Future<bool> allow) {
    _allowLeaveFutures.add(allow);
  }

  StatePreLeaveEvent _clone() => new StatePreLeaveEvent(path, state);
}


/**
 * Event emitted when routing starts.
 */
class RouteStartEvent {
  /**
   * URI that was passed to [Statechart.route].
   */
  final String uri;

  /**
   * Future that completes to a boolean value indicating if routing was successful (true) or not (false).
   */
  final Future<bool> completed;

  RouteStartEvent._new(this.uri, this.completed);
}


/**
 * Stores a set of [UrlPattern] to [Handler] associations and provides methods for calling
 * a handler for a given URL path.
 */
class Statechart {
  final State pivot;
  final _onRouteStart = new StreamController<RouteStartEvent>.broadcast(sync: true);
  final bool loggingEnabled;

  Statechart({bool loggingEnabled: false}) : this._init(null, loggingEnabled: loggingEnabled);

  Statechart._init(State parent, {this.loggingEnabled})
  : pivot = new StateImpl._new() {
    if (this.loggingEnabled == true) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    }
  }

  /**
   * Returns a list of [String]s of state path segments from a provided state path.
   *
   * Example:
   *   State path: /a/a.1/a.1.1
   *   State path segments: ['/a', '/a.1', '/a.1.1.']
   */
  List<String> _segmentStatePath(String path) {
    var stateNames = path.split('/')
    .where((sn) => sn != '')
    .toList();

    var statePathSegments = stateNames
    .map((sn) => '/' + sn)
    .toList();

    return statePathSegments;
  }

  /**
   * A stream of route calls.
   */
  Stream<RouteStartEvent> get onRouteStart => _onRouteStart.stream;

  /**
   * Finds a matching [State] added with [addState] and invokes the associated callbacks.
   *
   * The route to a state (state node) is always a vector originating from the pivot node.
   * The route always ends at a leaf node (superstate) of the statechart. Routing to intermediate nodes (substates)
   * in the statechart is NOT possible in Harel statecharts.
   *
   * Routing always follows one of the following schemes:
   *
   * * Starts at the pivot node and progresses towards the target leaf node (accepting state). This is usually the
   * scheme used for the initial state transitions.
   *
   * * If routing to another orthogonal region in the statechart, routing starts at the current leaf node,
   * progresses towards the pivot node and then progresses to the target leaf node (accepting state)
   * in the other region.
   */
  Future goto(String path, {State startingFrom}) {
    var baseRoute = startingFrom == null ? this.pivot : _dehandle(startingFrom);
    return route(path, startingFrom: baseRoute).then((success) {
      return success;
    });
  }

  Future<bool> route(String path, {State startingFrom}) {
    _logger.finest('route $path');
    var statePathSegments = _segmentStatePath(path);
    var future = _route(statePathSegments, startingFrom);
    _onRouteStart.add(new RouteStartEvent._new(path, future));
    return future;
  }

  Future<bool> _route(List<String> statePathSegments, State startingFrom) {
    var routeBase = startingFrom == null ? pivot : _dehandle(startingFrom);
    _logger.finest('route $routeBase');
    var chartRoute = _matchingChartRoute(statePathSegments, routeBase);
    if (chartRoute.isEmpty) {
      return new Future.value(false);
    }
    var mustLeave = activeChartRoute;
    var leaveBase = pivot;

    return _preLeave(statePathSegments, mustLeave, chartRoute, leaveBase);
  }

  Future<bool> _preLeave(List<String> statePathSegments, Iterable<State> mustLeave, List<_Match> chartRoute, State leaveBase) {
    mustLeave = mustLeave.toList().reversed;

    var preLeaving = <Future<bool>>[];
    mustLeave.forEach((toLeave) {
      var event = new StatePreLeaveEvent('', toLeave);
      toLeave._onPreLeaveController.add(event);
      preLeaving.addAll(event._allowLeaveFutures);
    });
    return Future.wait(preLeaving).then((List<bool> results) {
      if (!results.any((r) => r == false)) {
        _leave(mustLeave, leaveBase);

        return _preEnter(statePathSegments, chartRoute);
      }
      return new Future.value(false);
    });
  }

  void _leave(Iterable<State> mustLeave, State leaveBase) {
    mustLeave.forEach((toLeave) {
      var event = new StateLeaveEvent('', toLeave);
      toLeave._onLeaveController.add(event);
    });
    if (!mustLeave.isEmpty) {
      _unsetAllCurrentStatesRecursively(leaveBase);
    }
  }

  void _unsetAllCurrentStatesRecursively(StateImpl s) {
    if (s._currentState != null) {
      _unsetAllCurrentStatesRecursively(s._currentState);
      s._currentState = null;
    }
  }

  Future<bool> _preEnter(List<String> statePathSegments, List<_Match> chartPath) {
    var toEnter = chartPath;
    var enterBase = pivot;

    for (var i = 0, ll = min(toEnter.length, activeChartRoute.length); i < ll; i++) {
      if (toEnter.first.state == activeChartRoute[i]) {
        toEnter = toEnter.skip(1);
        enterBase = enterBase._currentState;
      } else {
        break;
      }
    }
    if (toEnter.isEmpty) {
      return new Future.value(true);
    }

    var preEnterFutures = <Future<bool>>[];
    toEnter.forEach((_Match matchedState) {
      var preEnterEvent = new StatePreEnterEvent._fromMatch(matchedState);
      matchedState.state._onPreEnterController.add(preEnterEvent);
      preEnterFutures.addAll(preEnterEvent._allowEnterFutures);
    });
    return Future.wait(preEnterFutures).then((List<bool> results) {
      if (!results.any((v) => v == false)) {
        _enter(enterBase, toEnter);
        return new Future.value(true);
      }
      return new Future.value(false);
    });
  }

  _enter(StateImpl startingFrom, Iterable<_Match> chartPath) {
    var base = startingFrom;

    chartPath.forEach((_Match matchedState) {
      var event = new StateEnterEvent._fromMatch(matchedState);
      base._currentState = matchedState.state;
      base._currentState._lastEvent = event;
      matchedState.state._onEnterController.add(event);
      base = matchedState.state;
    });
  }

  List<StateImpl> _childStates(StateImpl routeBase) {
    var states = routeBase._states.values;
    return states;
  }

  List<StateImpl> _matchingStates(String statePathSegment, StateImpl routeBase) {
    var states = routeBase._states.values
    .where((s) => s.path.match(statePathSegment) != null)
    .toList();

    return states;
  }

  List<_Match> _matchingChartRoute(List<String> statePathSegments, StateImpl routeBase) {
    final chartRoute = <_Match>[];
    State matchedState;
    String statePathSegment;
    State childState;

    // Check if path provided is empty. If so, start the routing down the statechart by setting the first element
    // of the path segments list to the path of the first state in the first state tier in the statechart.
    if (statePathSegments.isEmpty) {
      statePathSegments.add(_childStates(pivot).first.sourcePath);
    }

    // Find state based on provided path or path fragment. The matched state can be either a substate or
    // a superstate (leaf state).
    for (var i = 0; i < statePathSegments.length; i++) {
      matchedState = null;
      statePathSegment = statePathSegments[i];

      List matchingStates = _matchingStates(statePathSegment, routeBase);

      if (matchingStates.isNotEmpty) {
        // Matching states were found.
        if (matchingStates.length > 1) {
          // TODO(adamjcook): Should this condition even be allowed to exist in the statechart?
          // More than 1 state was matched on the state tier. Only use the first state found.
          _logger.warning('More than one route matches the path provided $statePathSegment $matchingStates');
        }
        matchedState = matchingStates.first;
      } else {
        // Invalid state path encountered. Clear out contents of chartRoute and break out of the loop.
        chartRoute.clear();
        break;
      }

      if (matchedState != null) {
        var match = _getMatch(matchedState, statePathSegment);
        chartRoute.add(new _Match(matchedState, match));
        routeBase = matchedState;
      }
    }

    // Check if child states are under the last matched state. If so, only part of the state path was provided.
    // Also, check if were any parent states matched from the loop above. If not, the path provided tried to enter
    // states that do not exist in the statechart - which is an error and there is no need to enter this loop.
    //
    // If a partial state path was provided, the end of the state has not been reached yet (which is a requirement),
    // so continue down the state chart until the leaf state is reached.
    //
    // The default states at each state tier is the first state declared on each tier when [StateChart] was initialized.
    if (chartRoute.isNotEmpty && _childStates(routeBase).isNotEmpty) {
      do {
        childState = null;
        List childStates = _childStates(routeBase);
        if (childStates.isNotEmpty) {
          childState = childStates.first;
          var match = _getMatch(childState, childState.sourcePath);
          chartRoute.add(new _Match(childState, match));
          routeBase = childState;
        } else {
          break;
        }
      } while (childState != null);
    }

    return chartRoute;
  }

  /**
   * Returns a list of strings that represent the current active route or routes in the state tree.
   */
  List<String> current() {
    var res = <String>[];
    var statePath = '';
    var state = pivot;
    while (state._currentState != null) {
      state = state._currentState;
      statePath += state.sourcePath;
    }
    res.add(statePath);
    return res;
  }

  // TODO(adamjcook): Implement this.
  State _dehandle(State s) => s is StateHandle ? s._getHost(s) : s;

  /**
   * TODO(adamjcook): Add description here.
   */
  UrlMatch _getMatch(State state, String path) {
    var match = state.path.match(path);
    if (match == null) return new UrlMatch('');
    return match;
  }

  /**
   * Returns a list of [State]s that represent the current active route or routes in the state tree.
   */
  List<State> get activeChartRoute {
    var res = <StateImpl>[];
    var state = pivot;
    while (state._currentState != null) {
      state = state._currentState;
      res.add(state);
    }
    return res;
  }

}


class _Match {
  final StateImpl state;
  final UrlMatch urlMatch;

  _Match(this.state, this.urlMatch);

  toString() => state.toString();
}