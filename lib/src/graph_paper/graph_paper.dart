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

  DivElement _paper; // div tag with id #paper inside element template

  int _ppi = 96; // Pixels per inch at 100% zoom.

  GraphPaper.created() : super.created() {}

  @override
  void attached() {
    super.attached();

    // TODO(adamjcook): Currently, this is just output to the console, this needs to be accessible externally.
    onClick.
    listen((e){
      title = 'The grid area was clicked at:';
      var clickPoint = {'x': e.offset.x, 'y': e.offset.y}; clickPoints.insert(0, clickPoint);
      print(clickPoint);
    });

    _paper = $['paper'];

    changePaperSize();
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
    changePaperSize();
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

  void changePaperSize() {
    print('graph_paper :: changePaperSize()');
    if (units == 'inch') {
      if (paperSize == 'letter') {
        print('setting width and height for ' + paperSize);
        _paper.style.width = (8.5 * _ppi).toString() + 'px';
        _paper.style.height = (11 * _ppi).toString() + 'px';
      } else if (paperSize == 'legal') {
        print('setting width and height for ' + paperSize);
        _paper.style.width = (8.5 * _ppi).toString() + 'px';
        _paper.style.height = (14 * _ppi).toString() + 'px';
      } else if (paperSize == 'tabloid') {
        print('setting width and height for ' + paperSize);
        _paper.style.width = (11 * _ppi).toString() + 'px';
        _paper.style.height = (17 * _ppi).toString() + 'px';
      }
    }
  }

}