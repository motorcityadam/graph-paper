// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at http://adamjcook.github.io/graph-paper/LICENSE
// The complete set of contributors may be found at http://adamjcook.github.io/graph-paper/CONTRIBUTORS

library ui_drawer;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';

/**
 * TODO(adamjcook): add comments for this element
 */
@CustomTag('ui-drawer')
class UiDrawer extends PolymerElement {
  @observable ObservableMap drawerState = toObservable({
    'collapsed': false
  });

  @observable String units = 'inch';
  @observable double paperSize = 'letter';
  @observable String layout = 'portrait';
  @observable double gridSpacing = 0.3125;
  @observable double gridMargin = 0.1875;
  @observable String strokeWidth = 'thin';
  @observable bool snapToGrid = false;


  UiDrawer.created() : super.created() {
    print('ui_drawer :: created()');
  }

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

  /**
   * Watcher functions for changes in the UI controls.
   */
  void unitsChanged(String oldValue, String newValue) {
    print('ui.drawer :: unitsChanged()');
    if (newValue == 'mm') {
      paperSize = 'a4';
    }
    if (newValue == 'inch') {
      paperSize = 'letter';
    }
  }

  void paperSizeChanged(String oldValue, String newValue) {
    print('ui.drawer :: paperSizeChanged()');
    print(newValue);
  }

  void layoutChanged(String oldValue, String newValue) {
    print('ui.drawer :: layoutChanged()');
    print(newValue);
  }

  void gridSpacingChanged(double oldValue, double newValue) {
    print('ui.drawer :: gridSpacingChanged()');
    print(newValue);
  }

  void gridMarginChanged(double oldValue, double newValue) {
    print('ui.drawer :: gridMarginChanged()');
    print(newValue);
  }

  void strokeWidthChanged(String oldValue, String newValue) {
    print('ui.drawer :: strokeWidthChanged()');
    print(newValue);
  }

  void snapToGridChanged(String oldValue, String newValue) {
    print('ui.drawer :: snapToGridChanged()');
    print(newValue);
  }

}

upgradeUiDrawer() => Polymer.register('ui-drawer', UiDrawer);