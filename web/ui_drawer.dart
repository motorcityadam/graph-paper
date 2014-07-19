// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at http://adamjcook.github.io/graph-paper/LICENSE
// The complete set of contributors may be found at http://adamjcook.github.io/graph-paper/CONTRIBUTORS

library ui.drawer;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';

/**
 * TODO(adamjcook): add comments for this element
 */
@CustomTag('ui-drawer')
class UiDrawer extends PolymerElement {

  UiDrawer.created() : super.created() {
    print('ui.drawer :: main()');
  }

  @override
  void attached() {
    super.attached();
  }

  void toggleVisibility(Event e, var detail, Node target) {
    print('Hit');
  }

}

upgradeUiDrawer() => Polymer.register('ui-drawer', UiDrawer);