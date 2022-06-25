import 'package:flutter/material.dart';
import '../entities/step.dart';

class StepNotification extends Notification {
  final StepManif step;

  StepNotification(this.step);
}