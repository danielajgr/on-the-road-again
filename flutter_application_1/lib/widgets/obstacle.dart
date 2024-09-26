import 'package:flutter/material.dart';

class Obstacle {
  Obstacle({required this.type, required this.hitbox, required this.color});

  Rect hitbox;
  bool hit = false;
  final String type;
  Color color = Color.fromARGB(197, 255, 0, 0);

  void onCollision() {
    hit = true;
  }

  bool checkHit() {
    return hit;
  }
}
