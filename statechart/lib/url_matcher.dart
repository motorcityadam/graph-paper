// Copyright (c) 2014 Adam Joseph Cook. All rights reserved.
// This code may only be used under The MIT License found at https://github.com/adamjcook/statechart.dart/blob/master/LICENSE
// The complete set of contributors may be found at https://github.com/adamjcook/statechart.dart/blob/master/CONTRIBUTORS

library url_matcher;

/**
 * A URL matcher interface for statecharts.
 */
abstract class UrlMatcher extends Comparable<UrlMatcher> {
  /**
   * Attempts to match a provided URL. If the match is successful, then an [UrlMatch] instance is returned.
   * If not match is found, return a [null].
   */
  UrlMatch match(String url);

/**
 * Returns a value which is:
 *
 * * negative if this matcher should be tested BEFORE another.
 * * zero if this matcher and another can be tested in no particular order.
 * * positive if this matcher should be tested AFTER another.
 */
//  int compareTo(UrlMatcher other);
}

class UrlMatch {
  // Matched section of the URL
  final String match;

  UrlMatch(this.match);

  bool operator == (UrlMatch other) =>
  other is UrlMatch &&
  other.match == match;

  String toString() => '{$match}';
}