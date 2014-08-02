// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at http://adamjcook.github.io/graph-paper/LICENSE
// The complete set of contributors may be found at http://adamjcook.github.io/graph-paper/CONTRIBUTORS

library ui_drawer;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';
// TODO(adamjcook): remove local lib statechart, statechart should be pulled from pub.
//import 'package:statechart/client.dart';

/**
 * TODO(adamjcook): add comments for this element
 */
@CustomTag('ui-drawer')
class UiDrawer extends PolymerElement {
  @observable ObservableMap drawerState = toObservable({
    'collapsed': false
  });

  @published String units;
  @published String paperSize;
  @published String layout;
  @published double gridSpacing;
  @published double gridMargin;
  @published String strokeWidth;
//  @published bool snapToGrid;

//  StateImpl _state_chart;


  UiDrawer.created() : super.created() {}

  @override
  void attached() {
    super.attached();
//    _state_chart = initStatechart();
  }
//
//  StateImpl initStatechart() {
//    var state_chart = new Statechart();
//
//    state_chart.pivot
//      ..addState(
//        name: 'inch',
//        enter: (StateEvent e) => units='inch',
//        mount: (state_chart) => state_chart
//          ..addState(
//            name: 'letter',
//            enter: (StateEvent e) => paperSize='letter',
//            mount: (router) => router
//              ..addState(
//                name: 'portrait',
//                enter: (StateEvent e) => layout='portrait'
//            )
//              ..addState(
//                name: 'landscape',
//                enter: (StateEvent e) => layout='landscape'
//            )
//          )
//          ..addState(
//            name: 'legal',
//            enter: (StateEvent e) => paperSize='legal',
//            mount: (router) => router
//              ..addState(
//                name: 'portrait',
//                enter: (StateEvent e) => layout='portrait'
//            )
//              ..addState(
//                name: 'landscape',
//                enter: (StateEvent e) => layout='landscape'
//            )
//          )
//          ..addState(
//            name: 'tabloid',
//            enter: (StateEvent e) => paperSize='tabloid',
//            mount: (router) => router
//              ..addState(
//                name: 'portrait',
//                enter: (StateEvent e) => layout='portrait'
//            )
//              ..addState(
//                name: 'landscape',
//                enter: (StateEvent e) => layout='landscape'
//            )
//        )
//      )
//      ..addState(
//        name: 'mm',
//        enter: (StateEvent e) => units='mm',
//        mount: (state_chart) => state_chart
//          ..addState(
//            name: 'a4',
//            enter: (StateEvent e) => paperSize='a4',
//            mount: (router) => router
//              ..addState(
//                name: 'portrait',
//                enter: (StateEvent e) => layout='portrait'
//            )
//              ..addState(
//                name: 'landscape',
//                enter: (StateEvent e) => layout='landscape'
//            )
//          )
//          ..addState(
//            name: 'a3',
//            enter: (StateEvent e) => paperSize='a3',
//            mount: (router) => router
//              ..addState(
//                name: 'portrait',
//                enter: (StateEvent e) => layout='portrait'
//            )
//              ..addState(
//                name: 'landscape',
//                enter: (StateEvent e) => layout='landscape'
//            )
//          )
//        );
//
//    return state_chart;
//  }


  /**
   * Toggles the visibility of the drawer which contains the application controls.
   */
  void toggleVisibility(Event e, var detail, Node target) {
    drawerState['collapsed'] = !drawerState['collapsed'];
  }

  /**
   * Watcher functions for changes in the UI controls.
   */
//  void unitsChanged(String oldValue, String newValue) {
//    print('ui_drawer :: unitsChanged()');
//    print(newValue);
////    _state_chart.goto('/' + newValue);
//  }

}

upgradeUiDrawer() => Polymer.register('ui-drawer', UiDrawer);