// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at http://adamjcook.github.io/graph-paper/LICENSE
// The complete set of contributors may be found at http://adamjcook.github.io/graph-paper/CONTRIBUTORS

library example.bootstrap;

import 'package:core_elements/core_icon_button.dart';
import 'package:core_elements/core_toolbar.dart';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_checkbox.dart';
import 'package:paper_elements/paper_radio_group.dart';
import 'package:paper_elements/paper_shadow.dart';
import 'package:paper_elements/paper_slider.dart';

import 'package:graph_paper/graph_paper.dart';

void registerElementsWithPolymer() {
  // Initialize Polymer.
  startPolymer([], false);

  print('bootstrap :: registerElementsWithPolymer()');

  // Register Polymer components.
  upgradeCoreIconButton();
  upgradeCoreToolbar();
  upgradePaperCheckbox();
  upgradePaperRadioGroup();
  upgradePaperShadow();
  upgradePaperSlider();
  upgradeGraphPaper();
}