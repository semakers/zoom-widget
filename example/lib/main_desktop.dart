import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'app.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(new MyApp());
}