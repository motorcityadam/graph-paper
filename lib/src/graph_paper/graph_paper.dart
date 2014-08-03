// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at https://github.com/adamjcook/graph-paper/blob/master/LICENSE
// The complete set of contributors may be found at https://github.com/adamjcook/graph-paper/blob/master/CONTRIBUTORS

library graph_paper;

import 'dart:async';
import 'dart:html';
import 'dart:svg';

import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';


/**
 * graph-paper
 *
 * Summary:
 *   graph-paper provides a customizable user interface element for generating engineering graph paper.
 *
 * Attributes:
 *   | Name           | Type    | Default    | Description                                                                                                                                                      |
 *   | -------------- | ------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
 *   | units          | String  | 'inch'     | Available options are 'inch' and 'mm'. These are the measurement units used when computing paper size.                                                           |
 *   | paperSize      | String  | 'letter'   | Available options are 'letter', 'legal', 'tabloid' when the 'units' attribute is 'inch'. Available options are 'a4' and 'a3' when the 'units' attribute is 'mm'. |
 *   | layout         | String  | 'portrait' | Available options are 'portrait' and 'landscape'. This sets the orientation of the paper on the screen.                                                          |
 *   | gridSpacing    | double  | 0.1250     | Controls the spacing between two consecutive vertical and horizontal grid lines. A grid spacing value of '1' equals '96' pixels.                                 |
 *   | gridMargin     | double  | 0.1875     | Controls the margin around the grid area. A margin value of '1' equals '96' pixels.                                                                              |
 *   | loggingEnabled | boolean | false      | Activates logging to the console of various internal library events.                                                                                             |
 *
 */
@CustomTag('graph-paper')
class GraphPaper extends PolymerElement {
  @published String units = 'inch';
  @published String paperSize = 'letter';
  @published String layout = 'portrait';
  @published double gridSpacing = 0.1250;
  @published double gridMargin = 0.1875;
//  @published String strokeWidth = 'thin'; // TODO(adamjcook): Implement this.
//  @published bool snapToGrid = false; // TODO(adamjcook): Implement this.
  @published bool loggingEnabled = false;

  List clickPoints = toObservable([]);

  DivElement _paper;         // div tag with id #paper inside element template (wraps the entire paper)
  DivElement _paperContent;  // div tag with id #paper-content inside element template (wraps all content on the paper)
  DivElement _gridContainer; // div tag with id #grid-container inside element template (wraps the actual SVG grid)
  SvgSvgElement _svgElement = new SvgSvgElement();
  PatternElement _minorGridPattern = new PatternElement();
  PathElement _minorGridPath = new PathElement();
  PathElement _rightBorderGridPath = new PathElement();
  PathElement _bottomBorderGridPath = new PathElement();
  PathSegList _minorGridPathSegments;
  PathSegList _rightBorderPathSegments;
  PathSegList _bottomBorderPathSegments;
  double _ppi = 96.0;        // Pixels per inch at 100% zoom.

  final Logger _logger = new Logger('graph-paper');

  GraphPaper.created() : super.created() {}

  @override
  void attached() {
    super.attached();

    _paper = $['paper'];
    _paperContent = $['paper-content'];
    _gridContainer = $['grid-container'];

    _initLogging();
    _initSvgGrid();

    changePaperSize();
    changeGridMargin();
    changeGridSpacing();
  }

  void _initLogging() {
    if (loggingEnabled == true) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    }
  }

  void _initSvgGrid() {
    var defsElement = new DefsElement();
    var rectElement = new RectElement();

    _svgElement.setAttribute('width', '100%');
    _svgElement.setAttribute('height', '100%');
    _svgElement.setAttribute('zoomAndPan', 'disabled');
    _svgElement.setAttribute('currentscale', '2');
    _gridContainer.append(_svgElement);
    _svgElement.id = 'svg-grid';

    _svgElement.append(defsElement);

    _minorGridPattern.setAttribute('patternUnits', 'userSpaceOnUse');
    defsElement.append(_minorGridPattern);
    _minorGridPattern.id = 'minor-grid';

    _minorGridPath.setAttribute('fill', 'none');
    _minorGridPath.setAttribute('stroke', 'gray');
    _minorGridPath.setAttribute('stroke-width', '0.5');
    _minorGridPattern.append(_minorGridPath);

    _minorGridPathSegments = _minorGridPath.pathSegList;

    rectElement.setAttribute('width', '3000');
    rectElement.setAttribute('height', '3000');
    rectElement.setAttribute('fill', 'url(#minor-grid)');
    _svgElement.append(rectElement);
    rectElement.id = 'grid';

    _rightBorderGridPath.setAttribute('fill', 'none');
    _rightBorderGridPath.setAttribute('stroke', 'gray');
    _rightBorderGridPath.setAttribute('stroke-width', '0.5');
    _svgElement.append(_rightBorderGridPath);
    _bottomBorderGridPath.setAttribute('fill', 'none');
    _bottomBorderGridPath.setAttribute('stroke', 'gray');
    _bottomBorderGridPath.setAttribute('stroke-width', '0.5');
    _svgElement.append(_bottomBorderGridPath);

    _rightBorderPathSegments = _rightBorderGridPath.pathSegList;
    _bottomBorderPathSegments = _bottomBorderGridPath.pathSegList;

    _logger.info('SVG grid created for $gridSpacing spacing');
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
    changeGridSpacing();
  }

  void paperSizeChanged(String oldValue, String newValue) {
    changePaperSize();
    changeLayout();
    changeGridSpacing();
  }

  void layoutChanged(String oldValue, String newValue) {
    changeLayout();
    changeGridSpacing();
  }

  void gridSpacingChanged(double oldValue, double newValue) {
    changeGridSpacing();
  }

  void gridMarginChanged(double oldValue, double newValue) {
    changeGridMargin();
    changeGridSpacing();
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

  void changeGridMargin() {
    _paperContent.style.margin = _pixelsToString(gridMargin * _ppi);
    _logger.info('grid margin changed to $gridMargin');
  }

  void changeGridSpacing() {
    // Adjust minor grid body.
    _minorGridPattern.setAttribute('width', (gridSpacing * _ppi).toString());
    _minorGridPattern.setAttribute('height', (gridSpacing * _ppi).toString());
    _minorGridPathSegments.clear();
    _minorGridPathSegments.appendItem(_minorGridPath.createSvgPathSegMovetoAbs((gridSpacing * _ppi), 0));
    _minorGridPathSegments.appendItem(_minorGridPath.createSvgPathSegLinetoAbs(0, 0));
    _minorGridPathSegments.appendItem(_minorGridPath.createSvgPathSegLinetoAbs(0, (gridSpacing * _ppi)));

    // Add right and bottom borders around #grid-container.
    _rightBorderPathSegments.clear();
    _rightBorderPathSegments.appendItem(_rightBorderGridPath.createSvgPathSegMovetoAbs(_paperContent.offsetWidth, 0));
    _rightBorderPathSegments.appendItem(_rightBorderGridPath.createSvgPathSegLinetoAbs(_paperContent.offsetWidth, 0));
    _rightBorderPathSegments.appendItem(_rightBorderGridPath.createSvgPathSegLinetoAbs(_paperContent.offsetWidth, _paperContent.offsetHeight));
    _bottomBorderPathSegments.clear();
    _bottomBorderPathSegments.appendItem(_bottomBorderGridPath.createSvgPathSegMovetoAbs(0, _paperContent.offsetHeight));
    _bottomBorderPathSegments.appendItem(_bottomBorderGridPath.createSvgPathSegLinetoAbs(0, _paperContent.offsetHeight));
    _bottomBorderPathSegments.appendItem(_bottomBorderGridPath.createSvgPathSegLinetoAbs(_paperContent.offsetWidth, _paperContent.offsetHeight));

    _logger.info('grid spacing changed to $gridSpacing');
  }

}