// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at https://github.com/adamjcook/graph-paper/blob/master/LICENSE
// The complete set of contributors may be found at https://github.com/adamjcook/graph-paper/blob/master/CONTRIBUTORS

library ui_drawer;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';


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
//  @published String strokeWidth;
//  @published bool snapToGrid;

  UiDrawer.created() : super.created() {}

  @override
  void attached() {
    super.attached();
  }

  /**
   * Toggles the visibility of the drawer which contains the application controls.
   */
  void toggleVisibility(Event e, var detail, Node target) {
    drawerState['collapsed'] = !drawerState['collapsed'];
  }

}

upgradeUiDrawer() => Polymer.register('ui-drawer', UiDrawer);