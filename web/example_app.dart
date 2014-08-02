// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at http://adamjcook.github.io/graph-paper/LICENSE
// The complete set of contributors may be found at http://adamjcook.github.io/graph-paper/CONTRIBUTORS

library example_app;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';

@CustomTag('example-app')
class ExampleApp extends PolymerElement {

  @observable String units;
  @observable String paperSize;
  @observable String layout;
  @observable double gridSpacing;
  @observable double gridMargin;
  @observable String strokeWidth;
  @observable bool snapToGrid;

  ExampleApp.created() : super.created() {}

  @override
  void attached() {
    super.attached();
  }

}

upgradeExampleApp() => Polymer.register('example-app', ExampleApp);