import 'package:flutter/material.dart';

class Obstacle {
  Obstacle({required this.type, required this.hitbox});

  final Rect hitbox;
  bool hit = false;
  final String type;

  void onCollision() {
    hit = true;
  }

  void resetObstacles() {
    hit = false;
  }
}
