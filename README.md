graph-paper
===========

Web component for generating various types of engineering graph paper using SVG, written in Dart and Polymer.

## Overview

![Screenshot](https://raw.githubusercontent.com/adamjcook/graph-paper/master/doc/screenshot.png)

graph-paper provides a customizable user interface element for generating engineering graph paper.

## Attributes

 * **loggingEnabled** [boolean] Default is false. Activates logging to the console of various internal library events.
 * **paperSize** [String] Default is 'letter'. Available options are 'letter', 'legal', 'tabloid', 'a5', a4' and 'a3'.
 * **layout** [String] Default is 'portrait'. Available options are 'portrait' and 'landscape'. This sets the orientation of the paper on the screen.
 * **gridSpacing** [double] Default is 12. Units are in pixels. Controls the spacing between two consecutive vertical and horizontal grid lines.
 * **gridMargin** [double] Default is 18. Units are in pixels. Controls the margin around the grid area.
   
## Status

Please note that this is a beta release of this package and API changes are very probable while this package is in beta.

## Using Elements

All elements live at the top-level of the `lib/` folder.

Import into HTML:

    <link rel="import" href="packages/graph_paper/graph_paper.html">

Import into Dart:

    import 'package:graph_paper/graph_paper.dart';
    
## Build Notes

Use the `update.dart` script to build the import .html and .dart files based on the sources in the `lib/src` directory.
The `update.dart` tool expects to be run in the repository root.

To build this project, run the following command from the repository root of the project:

    ./tool/update.dart lib/src/graph_paper/graph_paper.html
    
## Running Sample Application

To run the sample application, run the following command from the repository root of the project:

    pub serve