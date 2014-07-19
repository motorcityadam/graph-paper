// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at http://adamjcook.github.io/graph-paper/LICENSE
// The complete set of contributors may be found at http://adamjcook.github.io/graph-paper/CONTRIBUTORS

library example.bootstrap;

import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_shadow.dart';

import 'package:graph_paper/graph_paper.dart';

void registerElementsWithPolymer() {
  // Initialize Polymer.
  startPolymer([], false);

  print('bootstrap :: registerElementsWithPolymer()');

  // Register Polymer components.
  upgradePaperShadow();
  upgradeGraphPaper();
}