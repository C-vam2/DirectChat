import 'package:flutter/material.dart';

class SettingsListItem {
  IconData icon;
  String title;
  Widget? widget;
  Function? function;
  SettingsListItem(
      {required this.icon, required this.title, this.widget, this.function});
}
