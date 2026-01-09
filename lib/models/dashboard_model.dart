import 'package:flutter/material.dart';

class DashboardItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? route;

  DashboardItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.route,
  });
}
