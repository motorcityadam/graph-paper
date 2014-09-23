library graph_paper;

import 'dart:html';
import 'dart:svg';

import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';

import './utilities.dart' as utils;


/**
 * graph-paper
 *
 * Summary:
 * 
 *  graph-paper provides a customizable user interface element for generating 
 *  engineering graph paper.
 *
 * 
 * Attributes:
 * 
 *  loggingEnabled [boolean] Default is false. Activates logging to the console 
 *    of various internal library events.
 * 
 *  paperSize [String] Default is 'letter'. Available options are 'letter', 
 *    'legal', 'tabloid', 'a5', a4' and 'a3'.
 * 
 *  layout [String] Default is 'portrait'. Available options are 'portrait' and 
 *    'landscape'. This sets the orientation of the paper on the screen.
 * 
 *  gridSpacing [double] Default is 12. Units are in pixels. Controls the 
 *    spacing between two consecutive vertical and horizontal grid lines.
 * 
 *  gridMargin [double] Default is 18. Units are in pixels. Controls the margin 
 *    around the grid area.
 * 
 *  majorGridIncrement [int] By default, a major grid is not drawn. If this 
 *    attribute is not set, no major grid will be drawn. Controls the number of 
 *    grid squares that should be skipped (in the vertical and horizontal 
 *    directions) before a major grid line is drawn. The origin starts in the 
 *    upper, left-hand corner of the grid. Major grid lines are represented, by 
 *    default, by a thicker line than their minor grid counterparts.
 * 
 *  minorGridColor [String] By default, the minor grid is `gray`. Controls the 
 *    color of the minor grid lines. This attribute can be any color or color
 *    designation that is valid in CSS (for example, `red`, `#990000`, 
 *    `rgb(255,0,0)`, `rgba(255,0,0,0.2)`, `hsl(120,100%,50%)`...etc.).
 *    Note that CMYK color functions are not supported in any current browser.
 * 
 *  majorGridColor [String] By default, the major grid is `gray`. Controls the 
 *    color of the major grid lines. This attribute can be any color or color
 *    designation that is valid in CSS (for example, `red`, `#990000`, 
 *    `rgb(255,0,0)`, `rgba(255,0,0,0.2)`, `hsl(120,100%,50%)`...etc.).
 *    Note that CMYK color functions are not supported in any current browser.
 * 
 *  paperColor [String] By default, the paper color is `white`. Controls the 
 *    color of the paper. This attribute can be any color or color
 *    designation that is valid in CSS (for example, `red`, `#990000`, 
 *    `rgb(255,0,0)`, `rgba(255,0,0,0.2)`, `hsl(120,100%,50%)`...etc.).
 *    Note that CMYK color functions are not supported in any current browser.
 * 
 *  gridVisible [bool] By default, the grid is visible. Controls the visibility
 *    of the grid on the paper.
 * 
 *  snapToGrid [bool] By default, the selection handle will 'snap' to the
 *    nearest grid line intersection point. Toggling the value of this attribute
 *    will not effect the current location of the selection handle; only the
 *    next selection will be affected. 
 */
@CustomTag('graph-paper')
class GraphPaper extends PolymerElement {
  @published bool loggingEnabled = false;
  @published String paperSize = 'letter';
  @published String layout = 'portrait';
  @published double gridSpacing = 12.0;
  @published double gridMargin = 18.0;
  @published int majorGridIncrement = 0;
  @published String minorGridColor = 'gray';
  @published String majorGridColor = 'gray';
  @published String paperColor = 'white';
  @published bool gridVisible = true;
  @published bool snapToGrid = true;

  DivElement _paper;         // div tag with id #paper inside element template (wraps the entire paper)
  DivElement _paperContent;  // div tag with id #paper-content inside element template (wraps all content on the paper)
  DivElement _gridContainer; // div tag with id #grid-container inside element template (wraps the actual SVG grid)
  DivElement _handle = new DivElement();
  SvgSvgElement _svgElement = new SvgSvgElement();
  PatternElement _minorGridPattern = new PatternElement();
  PatternElement _majorGridPattern = new PatternElement();
  PathElement _minorGridPath = new PathElement();
  PathElement _majorGridPath = new PathElement();
  PathElement _rightBorderGridPath = new PathElement();
  PathElement _bottomBorderGridPath = new PathElement();
  PathSegList _minorGridPathSegments;
  PathSegList _majorGridPathSegments;
  PathSegList _rightBorderPathSegments;
  PathSegList _bottomBorderPathSegments;
  double _ppi = 96.0;        // Pixels per inch at 100% zoom.

  final Logger _logger = new Logger('graph-paper');

  GraphPaper.created() : super.created() {}

  @override
  void attached() {
    super.attached();

    assert(['letter', 'legal', 'tabloid', 'a5', 'a4', 'a3'].contains(paperSize));
    assert(['portrait', 'landscape'].contains(layout));

    _paper = $['paper'];
    _paperContent = $['paper-content'];
    _gridContainer = $['grid-container'];

    _initLogging();
    _initSvgGrid();
    _initSelectionSystem();

    changePaperSize();
    changeGridMargin();
    changeGridSpacing();
    changeMajorGridIncrement();
    changeMinorGridColor();
    changeMajorGridColor();
    changePaperColor();
    changeGridVisible();
    changeSnapToGrid();
  }

  // ===================== BEGIN INITIALIZATIONS =====================

  void _initLogging() {
    if (loggingEnabled == true) {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((LogRecord rec) {
        print('${rec.level.name}: ${rec.time}: ${rec.message}');
      });
    }
    _logger.info('Logging system initialized');
  }

  void _initSvgGrid() {
    var defsElement = new DefsElement();
    var minorGridRectElement = new RectElement();
    var majorGridRectElement = new RectElement();

    // Set attributes on `svg` element.
    _svgElement.setAttribute('width', '100%');
    _svgElement.setAttribute('height', '100%');
    _svgElement.setAttribute('zoomAndPan', 'disabled');
    _svgElement.setAttribute('currentscale', '1');
    _gridContainer.append(_svgElement);
    _svgElement.id = 'svg-grid';

    // Add `defs` element as child of the `svg` element.
    _svgElement.append(defsElement);

    // ===================== BEGIN MINOR GRID =====================
    // This is for the minor grid.
    // Set `patternUnits` attribute on the `pattern` element, add it as a
    // child of the `defs` element. The height and width (in pixels) of each 
    // discrete pattern unit will be set in the changeGridSpacing() function
    // below when the `gridSpacing` attribute is set or changed on the
    // `graph-paper` element.
    _minorGridPattern.setAttribute('patternUnits', 'userSpaceOnUse');
    defsElement.append(_minorGridPattern);
    _minorGridPattern.id = 'minor-grid';

    // This is for the minor grid.
    // Set attributes on the `path` element that is a child of the `pattern`
    // element. The `path` element describes the line segmenets that will be
    // drawn within each discrete pattern unit. For grid lines, the lines need
    // to be drawn around the outer borders of the discrete pattern unit.
    // Therefore, the line segments (paths) will be drawn as the same pixel
    // length and height of the pattern unit. The paths will be drawn at the
    // top and left-hand side of the pattern unit. The length and height of
    // these paths will be set in the changeGridSpacing() function below.
    _minorGridPath.setAttribute('fill', 'none');
    _minorGridPath.setAttribute('stroke', minorGridColor);
    _minorGridPath.setAttribute('stroke-width', '1.0');
    _minorGridPattern.append(_minorGridPath);

    // This is for the minor grid.
    // A path consists of segments, this is added to the `d` attribute of the
    // `path` element here. The exact nature of these path segments will be set 
    // in the changeGridSpacing() function below.
    _minorGridPathSegments = _minorGridPath.pathSegList;

    // This is for the minor grid.
    // Set attributes on `rect` element. The `rect` element is set to a size
    // of 3000 pixels by 3000 pixels and this element is filled by the grid
    // pattern represented by the #minor-grid id element (`pattern` element).
    minorGridRectElement.setAttribute('width', '3000');
    minorGridRectElement.setAttribute('height', '3000');
    minorGridRectElement.setAttribute('fill', 'url(#minor-grid)');
    _svgElement.append(minorGridRectElement);
    minorGridRectElement.id = 'minor-grid-rect';
    // ===================== END MINOR GRID =====================
    
    // ===================== BEGIN MAJOR GRID =====================
    _majorGridPattern.setAttribute('patternUnits', 'userSpaceOnUse');
    defsElement.append(_majorGridPattern);
    _majorGridPattern.id = 'major-grid';

    _majorGridPath.setAttribute('fill', 'none');
    _majorGridPath.setAttribute('stroke', majorGridColor);
    _majorGridPath.setAttribute('stroke-width', '2.0');
    _majorGridPattern.append(_majorGridPath);

    _majorGridPathSegments = _majorGridPath.pathSegList;

    majorGridRectElement.setAttribute('width', '3000');
    majorGridRectElement.setAttribute('height', '3000');
    majorGridRectElement.setAttribute('fill', 'url(#major-grid)');
    _svgElement.append(majorGridRectElement);
    majorGridRectElement.id = 'major-grid-rect';
    // ===================== END MAJOR GRID =====================

    // Since the path segments in each pattern unit only draw lines at the top
    // and left-hand side of each pattern unit, the right and bottom sides of
    // the `rect` element will have no grid lines. Border lines on the right
    // and the bottom of the grid pattern are added here.
    _rightBorderGridPath.setAttribute('fill', 'none');
    _rightBorderGridPath.setAttribute('stroke', minorGridColor);
    _rightBorderGridPath.setAttribute('stroke-width', '1.0');
    _svgElement.append(_rightBorderGridPath);
    _bottomBorderGridPath.setAttribute('fill', 'none');
    _bottomBorderGridPath.setAttribute('stroke', minorGridColor);
    _bottomBorderGridPath.setAttribute('stroke-width', '1.0');
    _svgElement.append(_bottomBorderGridPath);

    _rightBorderPathSegments = _rightBorderGridPath.pathSegList;
    _bottomBorderPathSegments = _bottomBorderGridPath.pathSegList;

    _logger.info('SVG grid created for $gridSpacing spacing');
  }

  void _initSelectionSystem() {
    

    // Add handle to default #grid-container at starting location
    // (upper, left-hand corner).
    _handle.id = 'handle';
    _resetHandleLocation();
    _gridContainer.append(_handle);

    _gridContainer
      .onClick
        .listen((e) {
          title = 'Grid area was clicked at:';
          var click = {'x': e.offset.x, 'y': e.offset.y};
          if (snapToGrid == true) {
            var intersection = _locateNearestGridIntersect(click['x'], click['y']);
            _handle.style.top = utils.pixelsToString(-3 + intersection['dy']);
            _handle.style.left = utils.pixelsToString(-3 + intersection['dx']);
            _logger.info("user selected x: ${ click['x'] } y: ${ click['y'] }");
            _logger.info("nearest intersection at x: ${ intersection['dx'] } y: ${ intersection['dy'] }");
          } else {
            _handle.style.top = utils.pixelsToString(-3 + click['y']);
            _handle.style.left = utils.pixelsToString(-3 + click['x']);
            _logger.info("user selected x: ${ click['x'] } y: ${ click['y'] }");
          }
        });

    _logger.info('Selection system initialized');
  }

  void _resetHandleLocation() {
    _handle.style.top = utils.pixelsToString(-3);
    _handle.style.left = utils.pixelsToString(-3);
  }

  Map<String, num> _locateNearestGridIntersect( num x, num y ) {
    var dx;
    var dy;
    var modulusX = x % gridSpacing;
    var modulusY = y % gridSpacing;

    var maxRight = utils.stringToPixels( _paper.style.width ) - ( 2 * gridMargin );
    var maxBottom = utils.stringToPixels( _paper.style.height ) - ( 2 * gridMargin );

    if ( modulusX == 0 && modulusY == 0 ) {
      // User clicked on an intersection, no computation necessary.
      dx = x;
      dy = y;

    } else {
      // User clicked outside of an intersection, find the nearest intersection.
      
      // Find nearest X intersection point.
      var leftGap = modulusX;
      var rightGap = gridSpacing - leftGap;

      if ( leftGap > rightGap ) dx = x + rightGap;
      if ( leftGap <= rightGap ) dx = x - leftGap;

      // Find nearest Y intersection point.
      var topGap = modulusY;
      var bottomGap = gridSpacing - topGap;

      if ( topGap > bottomGap ) dy = y + bottomGap;
      if ( topGap <= bottomGap ) dy = y - topGap;

      if ( dx > maxRight ) dx = maxRight;
      if ( dy > maxBottom ) dy = maxBottom;

    }

    return { 'dx': dx, 'dy': dy };
  }

  // ===================== END INITIALIZATIONS =====================

  /**
   * Watcher functions for attribute changes on element.
   */
  void paperSizeChanged(String oldValue, String newValue) {
    changePaperSize();
    changeLayout();
    changeGridSpacing();
    _resetHandleLocation();
  }

  void layoutChanged(String oldValue, String newValue) {
    changeLayout();
    changeGridSpacing();
    _resetHandleLocation();
  }

  void gridSpacingChanged(double oldValue, double newValue) {
    changeGridSpacing();
    _resetHandleLocation();
  }

  void gridMarginChanged(double oldValue, double newValue) {
    changeGridMargin();
    changeGridSpacing();
    _resetHandleLocation();
  }

  void majorGridIncrementChanged(int oldValue, int newValue) {
    changeMajorGridIncrement();
  }

  void minorGridColorChanged(String oldValue, String newValue) {
    changeMinorGridColor();
  }

  void majorGridColorChanged(String oldValue, String newValue) {
    changeMajorGridColor();
  }

  void paperColorChanged(String oldValue, String newValue) {
    changePaperColor();
  }

  void gridVisibleChanged(bool oldValue, bool newValue) {
    changeGridVisible();
  } 

  void snapToGridChanged(bool oldValue, bool newValue) {
    changeSnapToGrid();
  }

  void changePaperSize() {
    if (paperSize == 'letter') {
      _paper.style.width = utils.pixelsToString((8.5 * _ppi));
      _paper.style.height = utils.pixelsToString((11.0 * _ppi));
    } else if (paperSize == 'legal') {
      _paper.style.width = utils.pixelsToString((8.5 * _ppi));
      _paper.style.height = utils.pixelsToString((14.0 * _ppi));
    } else if (paperSize == 'tabloid') {
      _paper.style.width = utils.pixelsToString((11.0 * _ppi));
      _paper.style.height = utils.pixelsToString((17.0 * _ppi));
    } else if (paperSize == 'a5') {
      _paper.style.width = utils.pixelsToString(((148/25.4) * _ppi));
      _paper.style.height = utils.pixelsToString(((210/25.4) * _ppi));
    } else if (paperSize == 'a4') {
      _paper.style.width = utils.pixelsToString(((210/25.4) * _ppi));
      _paper.style.height = utils.pixelsToString(((297/25.4) * _ppi));
    } else if (paperSize == 'a3') {
      _paper.style.width = utils.pixelsToString(((297/25.4) * _ppi));
      _paper.style.height = utils.pixelsToString(((420/25.4) * _ppi));
    }
    _logger.info('paper size changed to $paperSize');
  }

  void changeLayout() {
    var oldWidth = utils.stringToPixels(_paper.style.width);
    var oldHeight = utils.stringToPixels(_paper.style.height);

    if ((layout == 'portrait' && (oldWidth > oldHeight)) ||
        (layout == 'landscape' && (oldWidth < oldHeight))) {
      _paper.style.width = utils.pixelsToString(oldHeight);
      _paper.style.height = utils.pixelsToString(oldWidth);
    }
    _logger.info('layout changed to $paperSize $layout');
  }

  void changeGridMargin() {
    _paperContent.style.margin = utils.pixelsToString(gridMargin);
    _logger.info('grid margin changed to $gridMargin');
  }

  void changeGridSpacing() {
    // Adjust minor grid body.
    _minorGridPattern.setAttribute('width', (gridSpacing).toString());
    _minorGridPattern.setAttribute('height', (gridSpacing).toString());
    _minorGridPathSegments.clear();
    _minorGridPathSegments.appendItem(_minorGridPath.createSvgPathSegMovetoAbs((gridSpacing), 0));
    _minorGridPathSegments.appendItem(_minorGridPath.createSvgPathSegLinetoAbs(0, 0));
    _minorGridPathSegments.appendItem(_minorGridPath.createSvgPathSegLinetoAbs(0, (gridSpacing)));

    // Add right and bottom borders around #grid-container.
    _rightBorderPathSegments.clear();
    _rightBorderPathSegments.appendItem(_rightBorderGridPath.createSvgPathSegMovetoAbs(_paperContent.offsetWidth, 0));
    _rightBorderPathSegments.appendItem(_rightBorderGridPath.createSvgPathSegLinetoAbs(_paperContent.offsetWidth, 0));
    _rightBorderPathSegments.appendItem(_rightBorderGridPath.createSvgPathSegLinetoAbs(_paperContent.offsetWidth, _paperContent.offsetHeight));
    _bottomBorderPathSegments.clear();
    _bottomBorderPathSegments.appendItem(_bottomBorderGridPath.createSvgPathSegMovetoAbs(0, _paperContent.offsetHeight));
    _bottomBorderPathSegments.appendItem(_bottomBorderGridPath.createSvgPathSegLinetoAbs(0, _paperContent.offsetHeight));
    _bottomBorderPathSegments.appendItem(_bottomBorderGridPath.createSvgPathSegLinetoAbs(_paperContent.offsetWidth, _paperContent.offsetHeight));

    changeMajorGridIncrement();

    _logger.info('minor grid spacing changed to $gridSpacing');
  }

  void changeMajorGridIncrement() {
    if (majorGridIncrement == 0) {
      return;
    }

    // Adjust major grid body.
    _majorGridPattern.setAttribute('width', (gridSpacing*majorGridIncrement).toString());
    _majorGridPattern.setAttribute('height', (gridSpacing*majorGridIncrement).toString());
    _majorGridPathSegments.clear();
    _majorGridPathSegments.appendItem(_majorGridPath.createSvgPathSegMovetoAbs((gridSpacing*majorGridIncrement), 0));
    _majorGridPathSegments.appendItem(_majorGridPath.createSvgPathSegLinetoAbs(0, 0));
    _majorGridPathSegments.appendItem(_majorGridPath.createSvgPathSegLinetoAbs(0, (gridSpacing*majorGridIncrement)));

    _logger.info('major grid incremenet changed to $majorGridIncrement');
  }

  void changeMinorGridColor() {
    _minorGridPath.setAttribute('stroke', minorGridColor);
    _rightBorderGridPath.setAttribute('stroke', minorGridColor);
    _bottomBorderGridPath.setAttribute('stroke', minorGridColor);

    _logger.info('minor grid color changed to $minorGridColor');
  }

  void changeMajorGridColor() {
    _majorGridPath.setAttribute('stroke', majorGridColor);

    _logger.info('major grid color changed to $majorGridColor');
  }

  void changePaperColor() {
    _paper.style.background = paperColor;

    _logger.info('paper color changed to $paperColor');
  }

  void changeGridVisible() {
    if (gridVisible == false) {
      _svgElement.attributes['invisible'] = '';
    } else {
      _svgElement.attributes.remove('invisible');
    }
    
    _logger.info('grid visibility changed to $gridVisible');
  }

  void changeSnapToGrid() {
    _logger.info('snapping to grid changed to $snapToGrid');
  }
}