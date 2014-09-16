graph-paper
===========

Web component for generating various types of engineering graph paper using SVG, written in Dart and Polymer.

## Overview

![Screenshot](https://raw.githubusercontent.com/adamjcook/graph-paper/master/doc/screenshot.png)

graph-paper provides a customizable user interface element for generating engineering graph paper.

## Demonstration Application

Please visit the interactive [demonstration application](http://graph-paper-demo.appspot.com/).

## Attributes

 * **loggingEnabled** [boolean] Default is false. Activates logging to the console of various internal library events.
 * **paperSize** [String] Default is 'letter'. Available options are 'letter', 'legal', 'tabloid', 'a5', a4' and 'a3'.
 * **layout** [String] Default is 'portrait'. Available options are 'portrait' and 'landscape'. This sets the orientation of the paper on the screen.
 * **gridSpacing** [double] Default is 12. Units are in pixels. Controls the spacing between two consecutive vertical and horizontal grid lines.
 * **gridMargin** [double] Default is 18. Units are in pixels. Controls the margin around the grid area.
 * **majorGridIncrement** [int] By default, a major grid is not drawn. If this attribute is not set, no major grid will be drawn. Controls the number of grid squares that should be skipped (in the vertical and horizontal directions) before a major grid line is drawn. The origin starts in the upper, left-hand corner of the grid. Major grid lines are represented, by default, by a thicker line than their minor grid counterparts.
 * **minorGridColor** [String] By default, the minor grid is `gray`. Controls the color of the minor grid lines. This attribute can be any color or color designation that is valid in CSS (for example, `red`, `#990000`, `rgb(255,0,0)`, `rgba(255,0,0,0.2)`, `hsl(120,100%,50%)`...etc.). Note that CMYK color functions are not supported in any current browser.
 * **majorGridColor** [String] By default, the major grid is `gray`. Controls the color of the major grid lines. This attribute can be any color or color designation that is valid in CSS (for example, `red`, `#990000`, `rgb(255,0,0)`, `rgba(255,0,0,0.2)`, `hsl(120,100%,50%)`...etc.). Note that CMYK color functions are not supported in any current browser.
 * **paperColor** [String] By default, the paper color is `white`. Controls the color of the paper. This attribute can be any color or color designation that is valid in CSS (for example, `red`, `#990000`, `rgb(255,0,0)`, `rgba(255,0,0,0.2)`, `hsl(120,100%,50%)`...etc.). Note that CMYK color functions are not supported in any current browser.

## Example

    <graph-paper loggingEnabled="false"
                 paperSize="legal"
                 layout="landscape"
                 gridSpacing="12"
                 gridMargin="18"
                 majorGridIncrement="5"
                 minorGridColor="black"
                 majorGridColor="#990000"
                 paperColor="#eee"></graph-paper>
  
## External Styling

* To add a custom border around the paper (by default, there is no border):

    ```css
    graph-paper /deep/ #paper {
      border: 1px solid #8c8c8c;
    }
    ```

* To add a depth shadow around the paper:

    Add `<paper-shadow z="1"></paper-shadow>` directly adjacent to the
    `<graph-paper>` element. The `paper-shadow` element is from the
    paper_elements pub package. Increasing the `z` attribute on the 
    `paper-shadow` element, increases the appearance of depth.

    See the `web/example_app.html` for an example. The `paper-shadow`
    element is provided as a comment for illustration purposes.

## Status

Please note that this is a beta release of this package and API changes are very probable while this package is in beta.

## Using Elements

All elements live at the top-level of the `lib/` folder.

Import into HTML:

`<link rel="import" href="packages/graph_paper/graph_paper.html">`

Import into Dart:

`import 'package:graph_paper/graph_paper.dart';`
    
## Build Notes

Use the `update.dart` script to build the import .html and .dart files based on the sources in the `lib/src` directory.
The `update.dart` tool expects to be run in the repository root.

To build this project, run the following command from the repository root of the project:

    ./tool/update.dart lib/src/graph_paper/graph_paper.html

## Running Example Application

To run the example application, run the following command from the repository root of the project:

    pub serve

After the command completes, visit the following address in a web browser of choice:

`http://localhost:8080`

Please note that the Dartium web browser that ships with the Dart SDK can run the Dart code natively (as it includes the Dart VM), but that all other browsers must have the Dart code transpiled to JavaScript. When using the `pub serve` command, the Dart2JS compiler included with the Dart SDK performs the transpiling automatically. However, there may be some noticable "lag" in loading the example application while the Dart code is being transformed.

## Contributing

Thank you for your consideration! Please review the [Contributing Guidelines][contributing].

[contributing]: https://github.com/adamjcook/graph-paper/blob/master/CONTRIBUTING.md