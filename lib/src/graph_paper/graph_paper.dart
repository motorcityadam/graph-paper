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
  @published double paperSizeX = 8.5;
  @published double paperSizeY = 11.0;
  @published String layout = 'portrait';
  @published double gridSpacing = 0.3125;
  @published double gridMargin = 0.1875;
  @published String strokeWidth = 'thin';

  List clicks = toObservable([]);

  GraphPaper.created() : super.created() {}

  @override
  void attached() {
    super.attached();

    // TODO(adamjcook): DRY: use 'this' to get tag name of element.
    ownerDocument.
    getElementsByTagName('graph-paper')[0].
    onClick.
    listen((e){
      title = 'The grid area was clicked at:';
      var click = {'x': e.offset.x, 'y': e.offset.y}; clicks.insert(0, click);
      print(click);
//      fire('grid-click', detail: click);
    });
  }

}