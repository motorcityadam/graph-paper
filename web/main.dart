// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at http://adamjcook.github.io/graph-paper/LICENSE
// The complete set of contributors may be found at http://adamjcook.github.io/graph-paper/CONTRIBUTORS

library example.main;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart' as polymer;
//import 'package:alliedview_widgets/alliedview_button/alliedview_button.dart';

import 'bootstrap.dart';

@polymer.initMethod
void main() {
  print('example :: main()');
  registerElementsWithPolymer();
}