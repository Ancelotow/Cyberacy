import 'package:flutter/material.dart';

class NavigationNotification<T extends Widget> extends Notification {
  final T page;

  NavigationNotification(this.page);
}