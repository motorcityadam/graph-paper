// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at http://adamjcook.github.io/graph-paper/LICENSE
// The complete set of contributors may be found at http://adamjcook.github.io/graph-paper/CONTRIBUTORS

library graph_paper;

import 'dart:async';
import 'dart:html';

import 'package:logging/logging.dart';
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
//  @published bool snapToGrid = false; // TODO(adamjcook): Implement this.
  @published bool loggingEnabled = false;

  List clickPoints = toObservable([]);

  DivElement _paper;        // div tag with id #paper inside element template
  DivElement _paperContent; // div tag with id #paper-content inside element template
  double _ppi = 96.0;       // Pixels per inch at 100% zoom.

  final Logger _logger = new Logger('graph-paper');

  GraphPaper.created() : super.created() {}

  @override
  void attached() {
    super.attached();

    _paper = $['paper'];
    _paperContent = $['paper-content'];

    _initLogging();
    changePaperSize();
    changeMargin();
  }

  void _initLogging() {
    if (loggingEnabled == true) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    }
  }

  String _pixelsToString(double pixels) {
    return pixels.toString() + 'px';
  }

  double _stringToPixels(String pixels_string) {
    return double.parse(pixels_string.replaceAll('px', ''));
  }

  /**
   * Watcher functions for attribute changes on element.
   */
  void unitsChanged(String oldValue, String newValue) {
    changeUnits();
    changePaperSize();
    changeLayout();
  }

  void paperSizeChanged(String oldValue, String newValue) {
    changePaperSize();
    changeLayout();
  }

  void layoutChanged(String oldValue, String newValue) {
    changeLayout();
  }

  void gridSpacingChanged(double oldValue, double newValue) {

  }

  void gridMarginChanged(double oldValue, double newValue) {
    changeMargin();
  }

  void strokeWidthChanged(String oldValue, String newValue) {

  }

//  void snapToGridChanged(String oldValue, String newValue) {
//
//  }

  void changeUnits() {
    if (units == 'inch') { paperSize = 'letter'; };
    if (units == 'mm') { paperSize = 'a4'; };
    _logger.info('units changed to $units');
  }

  void changePaperSize() {
    if (units == 'inch') {
      if (paperSize == 'letter') {
        _paper.style.width = _pixelsToString((8.5 * _ppi));
        _paper.style.height = _pixelsToString((11.0 * _ppi));
      } else if (paperSize == 'legal') {
        _paper.style.width = _pixelsToString((8.5 * _ppi));
        _paper.style.height = _pixelsToString((14.0 * _ppi));
      } else if (paperSize == 'tabloid') {
        _paper.style.width = _pixelsToString((11.0 * _ppi));
        _paper.style.height = _pixelsToString((17.0 * _ppi));
      }
    }
    if (units == 'mm') {
      if (paperSize == 'a4') {
        _paper.style.width = _pixelsToString(((210/25.4) * _ppi));
        _paper.style.height = _pixelsToString(((297/25.4) * _ppi));
      } else if (paperSize == 'a3') {
        _paper.style.width = _pixelsToString(((297/25.4) * _ppi));
        _paper.style.height = _pixelsToString(((420/25.4) * _ppi));
      }
    }
    _logger.info('paper size changed to $units $paperSize');
  }

  void changeLayout() {
    var oldWidth = _stringToPixels(_paper.style.width);
    var oldHeight = _stringToPixels(_paper.style.height);

    if ((layout == 'portrait' && (oldWidth > oldHeight)) ||
        (layout == 'landscape' && (oldWidth < oldHeight))) {
      _paper.style.width = _pixelsToString(oldHeight);
      _paper.style.height = _pixelsToString(oldWidth);
    }
    _logger.info('layout changed to $paperSize $layout');
  }

  void changeMargin() {
    _paperContent.style.margin = _pixelsToString(gridMargin * _ppi);
    _logger.info('margin changed to $gridMargin');
  }

}