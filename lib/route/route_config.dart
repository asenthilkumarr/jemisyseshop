import 'package:flutter/material.dart';
import 'package:jemisyseshop/main.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/view/masterPage.dart';
import 'package:jemisyseshop/view/productDetails.dart';
import 'package:jemisyseshop/view/productList.dart';

class Path {
  const Path(this.pattern, this.builder);

  /// A RegEx string for route matching.
  final String pattern;

  /// The builder for the associated pattern route. The first argument is the
  /// [BuildContext] and the second argument is a RegEx match if it is
  /// included inside of the pattern.
  final Widget Function(BuildContext, String) builder;
}

class RouteConfiguration {
  /// List of [Path] to for route matching. When a named route is pushed with
  /// [Navigator.pushNamed], the route name is matched with the [Path.pattern]
  /// in the list below. As soon as there is a match, the associated builder
  /// will be returned. This means that the paths higher up in the list will
  /// take priority.
  static List<Path> paths = [
    Path(
      r'^' + ProductDetailPage2.route,
          (context, match) => ProductDetailPage2(),
    ),
    Path(
      r'^' + ProductListPage2.route,
          (context, match) => ProductListPage2(),
    ),
    homeScreen == 1 ?
    Path(
      r'^' + MasterPage.route,
          (context, match) => MasterScreen(currentIndex: 0, key: null,),
    ) : Path(
      r'^' + MasterPage2.route,
          (context, match) => MasterPage2(currentIndex: 0, key: null,),
    ),
    Path(
      r'^' + SplashScreen.route,
          (context, match) => SplashScreen(),
    ),
  ];

  /// The route generator callback used when the app is navigated to a named
  /// route. Set it on the [MaterialApp.onGenerateRoute] or
  /// [WidgetsApp.onGenerateRoute] to make use of the [paths] for route
  /// matching.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    for (Path path in paths) {
      final regExpPattern = RegExp(path.pattern);
      if (regExpPattern.hasMatch(settings.name)) {
        final firstMatch = regExpPattern.firstMatch(settings.name);
        final match = (firstMatch.groupCount == 1) ? firstMatch.group(1) : null;
        return MaterialPageRoute<void>(
          builder: (context) => path.builder(context, match),
          settings: settings,
        );
      }
    }
    // If no match was found, we let [WidgetsApp.onUnknownRoute] handle it.
    return null;
  }
}
