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
//  @observable String strokeWidth;
//  @observable bool snapToGrid;

  ExampleApp.created() : super.created() {}

  @override
  void attached() {
    super.attached();
  }

}

upgradeExampleApp() => Polymer.register('example-app', ExampleApp);