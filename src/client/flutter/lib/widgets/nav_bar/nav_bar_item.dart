import 'package:flutter/material.dart';

class NavBarItem {
  final IconData icon;
  final String label;
  Function()? onTap;

  NavBarItem({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
  });
}

