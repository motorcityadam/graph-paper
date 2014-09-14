library example_app;

import 'dart:async';
import 'dart:html';

import 'package:polymer/polymer.dart';

@CustomTag('example-app')
class ExampleApp extends PolymerElement {

  @observable String paperSize;
  @observable String layout;
  @observable double gridSpacing;
  @observable double gridMargin;
  @observable int majorGridIncrement;
  @observable String minorGridColor;
  @observable String majorGridColor;
  @observable String paperColor;
//  @observable bool snapToGrid;

  ExampleApp.created() : super.created() {}

  @override
  void attached() {
    super.attached();
  }

}

upgradeExampleApp() => Polymer.register('example-app', ExampleApp);