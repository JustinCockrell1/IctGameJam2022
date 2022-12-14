import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:gamejam/classes/Endpoint.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:gamejam/main.dart';

class astroid extends SpriteAnimationComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  astroid() : super(size: Vector2.all(100.0)); // size + 100
  double vx = 0;
  double vy = 0;
  double distanceTravelled = 0;

  SpriteAnimationComponent astroidAnimation = SpriteAnimationComponent();
  final double _animationSpeed = 0.1;
  late final SpriteAnimation _astroidAnimation;
  int moveSpeed = 50;

  @override
  Future<void> onLoad() async {
    _loadAnimations().then((_) => {animation = _astroidAnimation});
    // add(CircleHitbox(
    //     radius: (size.x / 2) - 5,
    //     anchor: Anchor.topLeft,
    //     position: Vector2(10, 5)));
    super.onLoad();

    add(CircleHitbox());
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('meteorSheet.png'),
      srcSize: Vector2(128.0, 128.0),
    );
    _astroidAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 5);
  }

  void destroy() {
    gameRef.remove(this);
  }

  @override
  void update(double dt) {
    super.update(dt);
    double diffX = vx * dt * moveSpeed;
    double diffY = vy * dt * moveSpeed;
    position.x += diffX;
    position.y += diffY;
    distanceTravelled+=sqrt(diffX*diffX+diffY*diffY);
    if (distanceTravelled>2200) destroy();
  }
}
