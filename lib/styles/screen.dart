import 'dart:ui';
import 'package:flutter/material.dart';

class Screen {
  static double width = MediaQueryData.fromWindow(window).size.width;
  static double height = MediaQueryData.fromWindow(window).size.height;
  static double scale = MediaQueryData.fromWindow(window).devicePixelRatio;
  static double textScaleFactor = MediaQueryData.fromWindow(window).textScaleFactor;
  static double navigationBarHeight = MediaQueryData.fromWindow(window).padding.top + kToolbarHeight;
  static double topSafeHeight = MediaQueryData.fromWindow(window).padding.top;
  static double bottomSafeHeight = MediaQueryData.fromWindow(window).padding.bottom;
}