import 'package:flutter/material.dart';

/// Responsive layout helpers for phones & tablets.
class Responsive {
  Responsive._();

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).shortestSide >= 600;

  static double pad(BuildContext context) => isTablet(context) ? 24 : 16;

  static int gridColumns(BuildContext context) =>
      isTablet(context) ? 3 : 2;

  static double touchTarget(BuildContext context) =>
      isTablet(context) ? 88 : 72;

  static double emojiSize(BuildContext context) =>
      isTablet(context) ? 48 : 40;

  static double cardRadius(BuildContext context) =>
      isTablet(context) ? 28 : 22;

  /// Scale a value between phone (360w) and tablet (768w).
  static double scale(BuildContext context, double phone, [double? tablet]) {
    return isTablet(context) ? (tablet ?? phone * 1.25) : phone;
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
