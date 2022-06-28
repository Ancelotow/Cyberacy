import 'package:flutter/material.dart';

class SaveNotification<T> extends Notification {
  final T value;

  SaveNotification(this.value);
}