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