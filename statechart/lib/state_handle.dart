// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at https://github.com/adamjcook/statechart.dart/blob/master/LICENSE
// The complete set of contributors may be found at https://github.com/adamjcook/statechart.dart/blob/master/CONTRIBUTORS

part of statechart.client;

/**
 * A helper State handle that scopes all state change event subscriptions and listeners to its
 * instance and provides a convenience [discard] method.
 */
class StateHandle implements State {
  State _state;

  StateHandle._new(this._state) {}

  void discard() {
    _logger.finest('discarding handle for $_state');
    _state = null;
  }

  // Not supported. Overridden so that an error can be thrown.
  @override
  void addState({String name, Pattern path, mount}) {
    throw new UnsupportedError('addRoute is not supported within the handle.');
  }

  State _getHost(State s) {
    _assertState();
    if (s == null) throw new StateError('Passed state is null.');
    if ((s is State) && (s is !StateHandle)) return s;
    StateHandle sh = s;
    return sh._getHost(sh._state);
  }

  dynamic _assertState([f()]) {
    if (_state == null) {
      throw new StateError('This state handle is already discarded.');
    }
    return f == null ? null : f();
  }

  // See [State.isActive]
  @override
  bool get isActive => _state.isActive;

  // See [State.path]
  @override
  UrlMatcher get path => _state.path;

  // See [State.name]
  @override
  String get name => _state.name;

  // See [State.parent]
  @override
  State get parent => _state.parent;
}