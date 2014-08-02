// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at https://github.com/adamjcook/statechart.dart/blob/master/LICENSE
// The complete set of contributors may be found at https://github.com/adamjcook/statechart.dart/blob/master/CONTRIBUTORS

library url_template;

import 'url_matcher.dart';

class UrlTemplate implements UrlMatcher {
  RegExp _pattern;
  String _strPattern;

  String toString() => 'UrlTemplate($_pattern)';

  // TODO(adamjcook): Implement this?
//  int compareTo(UrlMatcher other) {
//
//  }

  UrlTemplate(String template) {
    _compileTemplate(template);
  }

  void _compileTemplate(String template) {
    _strPattern = '^' + template;
    _pattern = new RegExp(_strPattern);
  }

  UrlMatch match(String url) {
    var matches = _pattern.allMatches(url);
    if (matches.isEmpty) return null;
    Match match = matches.first;
    return new UrlMatch(match.group(0));
  }
}