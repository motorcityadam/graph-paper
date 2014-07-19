// DO NOT EDIT: auto-generated with graph_paper/generate_dart_api.dart

/// Dart API for the polymer element `graph_paper`.
library graph_paper.graph_paper;

import 'dart:html';
import 'dart:js' show JsArray;
import 'package:web_components/interop.dart' show registerDartType;
import 'package:polymer/polymer.dart' show initMethod;
import 'package:graph_paper/src/common.dart' show DomProxyMixin;

/// TODO(adamjcook): add summary of element and element options/attributes here
///
/// Options:
///
/// 1.  Units (units): inch* or mm
/// 2a. Paper size in X (paper-size-x) 8.5*
/// 2b. Paper size in Y (paper-size-y) 11*
/// 3.  Paper color (paper-color): (hex color code, i.e. #fff) #fff*
/// 4.  TODO(adamjcook): PPI (pixels per inch)???
/// 5.  Spacing (spacing):
///       if Units are inch: 0.1" to 2"
///       if Units are mm:   1mm to 40mm
/// 6.  Margin (margin):
///       if Units are inch: 0.2" to 2"
///       if Units are mm:   5mm to 20mm
/// 7.  Stroke width (stroke-width): 1*
///       thin:   1px
///       medium: 2px
///       thick:  3px
/// 8.  Stroke color (stroke-color): (hex color code, i.e. #e1e1e1) #e1e1e1*
/// 9a. Major line spacing in X (major-line-x-spacing): 0*
/// 9b. Major line spacing in Y (major-line-y-spacing): 0*
/// 10. TODO(adamjcook): Enable scalar zoom multipler???
/// 11. TODO(adamjcook): Enable snap points??? On click handler to find the nearest grid intersection and output it through graph-paper element API
class GraphPaper extends HtmlElement with DomProxyMixin {
  GraphPaper.created() : super.created();
}
