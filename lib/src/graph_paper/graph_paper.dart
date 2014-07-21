// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at http://adamjcook.github.io/graph-paper/LICENSE
// The complete set of contributors may be found at http://adamjcook.github.io/graph-paper/CONTRIBUTORS

library graph_paper;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';

/**
 * TODO(adamjcook): add comments for this element
 */
@CustomTag('graph-paper')
class GraphPaper extends PolymerElement {
  @published String units = 'inch';
  @published String paperSize = 'letter';
  @published String layout = 'portrait';
  @published double gridSpacing = 0.3125;
  @published double gridMargin = 0.1875;
  @published String strokeWidth = 'thin';
  @published String snapToGrid = false;

  List clickPoints = toObservable([]);

  GraphPaper.created() : super.created() {}

  @override
  void attached() {
    super.attached();
  }

  /**
   * Watcher functions for attribute changes on element.
   */
  void unitsChanged(String oldValue, String newValue) {
    print('graph_paper :: unitsChanged()');
    print(newValue);
  }

  void paperSizeChanged(String oldValue, String newValue) {
    print('graph_paper :: paperSizeChanged()');
    print(newValue);
  }

  void layoutChanged(String oldValue, String newValue) {
    print('graph_paper :: layoutChanged()');
    print(newValue);
  }

  void gridSpacingChanged(double oldValue, double newValue) {
    print('graph_paper :: gridSpacingChanged()');
    print(newValue);
  }

  void gridMarginChanged(double oldValue, double newValue) {
    print('graph_paper :: gridMarginChanged()');
    print(newValue);
  }

  void strokeWidthChanged(String oldValue, String newValue) {
    print('graph_paper :: strokeWidthChanged()');
    print(newValue);
  }

  void snapToGridChanged(String oldValue, String newValue) {
    print('graph_paper :: snapToGridChanged()');
    print(newValue);
  }


}