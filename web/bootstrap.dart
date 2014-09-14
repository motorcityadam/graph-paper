library bootstrap;

import 'package:core_elements/core_icon_button.dart';
import 'package:core_elements/core_toolbar.dart';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_checkbox.dart';
import 'package:paper_elements/paper_input.dart';
import 'package:paper_elements/paper_radio_group.dart';
import 'package:paper_elements/paper_shadow.dart';
import 'package:paper_elements/paper_slider.dart';

import 'package:graph_paper/graph_paper.dart';

import 'example_app.dart';
import 'ui_drawer.dart';

void registerElementsWithPolymer() {
  // Initialize Polymer.
  startPolymer([], false);

  // Register Polymer components
  upgradeGraphPaper();
  upgradeUiDrawer();
  upgradeExampleApp();
  upgradeCoreIconButton();
  upgradeCoreToolbar();
  upgradePaperCheckbox();
  upgradePaperInput();
  upgradePaperRadioGroup();
  upgradePaperShadow();
  upgradePaperSlider();
}