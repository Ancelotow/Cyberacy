import 'package:flutter/material.dart';

class RemoveNotification<T> extends Notification {
  final T value;

  RemoveNotification(this.value);
}