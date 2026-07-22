import 'package:flutter/material.dart';

/// Responsive layout helpers for phones, tablets & large screens.
class Responsive {
  Responsive._();

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 900;

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  static double pad(BuildContext context) {
    if (isLargeScreen(context)) return 32;
    if (isTablet(context)) return 24;
    return 16;
  }

  static int gridColumns(BuildContext context) {
    if (isLargeScreen(context)) return isLandscape(context) ? 5 : 4;
    if (isTablet(context)) return isLandscape(context) ? 4 : 3;
    return 2;
  }

  static double touchTarget(BuildContext context) {
    if (isLargeScreen(context)) return 96;
    if (isTablet(context)) return 88;
    return 72;
  }

  static double emojiSize(BuildContext context) {
    if (isLargeScreen(context)) return 56;
    if (isTablet(context)) return 48;
    return 40;
  }

  static double cardRadius(BuildContext context) {
    if (isLargeScreen(context)) return 32;
    if (isTablet(context)) return 28;
    return 22;
  }

  /// Max width for centered game content on wide screens.
  static double maxContentWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1200) return 960;
    if (w >= 900) return 780;
    if (isTablet(context)) return 680;
    return w;
  }

  /// Scale a value between phone and tablet/large.
  static double scale(BuildContext context, double phone, [double? tablet]) {
    if (isLargeScreen(context)) return tablet ?? phone * 1.4;
    if (isTablet(context)) return tablet ?? phone * 1.25;
    return phone;
  }

  /// Wraps child with max-width centering on tablets/desktops.
  static Widget centeredContent(BuildContext context, Widget child) {
    final maxW = maxContentWidth(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: child,
      ),
    );
  }
}

/// Clamps extreme text scaling that breaks toddler layouts.
class KidTextScaler extends StatelessWidget {
  const KidTextScaler({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final clamped = scaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.15);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: clamped),
      child: child,
    );
  }
}
