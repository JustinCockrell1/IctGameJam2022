// import 'dart:ffi';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:flame/game.dart';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:gamejam/classes/Bullet.dart';
import 'package:gamejam/classes/ScoreBoard.dart';
import 'package:gamejam/classes/astroid.dart';

import 'classes/Spaceship.dart';
import 'classes/Background.dart';

import 'classes/Endpoint.dart';
import 'components/StartComponent.dart';
import 'package:flame_audio/flame_audio.dart';

class SpaceShooterGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  //Declare variables
  late SpaceShip player;
  late EndPoint endPoint;
  Scoreboard scoreBoard = Scoreboard();
  bool left = false, right = false, up = false, down = false;

  Background _background = Background();

  //Sets it to debug mode or not - makes it display the hit boxes and coordinates
  @override
  bool get debugMode => false;

  //Increase the display on the scoreboard
  void increaseScore() {
    scoreBoard.score++;
    FlameAudio.play("dingadading.mp3");
  }

  //Key events
  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      if (paused) {
        //Restart the game

        overlays.remove("PauseMenu");
        player.position = size / 2;
        player.angle = radians(45);
        scoreBoard.score = 0;
        player.vx = 0;
        player.vy = 0;

        removeAll(children.where((element) => element is astroid));

        paused = false;
      } else {
        //FlameAudio.play("sound_test.mp3");

      }

      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  //Called once when the game starts - Used to load everything
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(_background);
    //Set the game screen to a consistent size on any monitor
    camera.viewport = FixedResolutionViewport(Vector2(800, 600));

    //Define variables
    player = SpaceShip()
      ..position = size / 2
      ..width = 50
      ..height = 50
      ..anchor = Anchor.center
      ..angle = radians(45);

    endPoint = EndPoint()
      ..position = Vector2(size.x - 50, 50)
      ..width = 50
      ..height = 50
      ..anchor = Anchor.center;

    //Add the components into the game
    add(ScreenHitbox());
    add(player);
    add(endPoint);
    add(scoreBoard);
    add(astroid()
      ..vx = Random(100).nextDouble()
      ..vy = Random(100).nextDouble());

    add(Bullet()
      ..vx = 10
      ..vy = 0
      ..spriteFile = "assets/images/enemyShot1.png"
      ..position = Vector2(300, 400)
      ..width = 10
      ..height = 10);

    //  camera.followComponent(player);
     FlameAudio.bgm.initialize();
    Future.delayed(const Duration(milliseconds: 1000), () {

// Here you can write your code

 
    FlameAudio.bgm.play("backgroundmusic.wav");

});
   
  }

  double timeToCreateAstroid = Random().nextInt(4) + 5;
  double timer = 0;

  astroid buildAsteroid() {
    astroid asteroid;
    Vector2 position =
        Vector2(Random().nextInt(700) + 50, Random().nextInt(500) + 50);

    int angle = Random().nextInt(360);

    double moveSpeed = Random().nextDouble() * 2;

    double vx = cos(angle);
    double vy = sin(angle);

    int distanceAway = Random().nextInt(200) + 1300;

    position.x += vx * distanceAway;
    position.y += vy * distanceAway;

    asteroid = astroid()
      ..position = position
      ..vx = -vx * moveSpeed
      ..vy = -vy * moveSpeed;

    return asteroid;
  }

  Bullet buildbullet() {
    Bullet bullet;
    Vector2 position =
        Vector2(Random().nextInt(700) + 50, Random().nextInt(500) + 50);

    int angle = Random().nextInt(360);

    double moveSpeed = Random().nextDouble() * 2;

    double vx = cos(angle);
    double vy = sin(angle);

    int distanceAway = Random().nextInt(200) + 1300;

    position.x += vx * distanceAway;
    position.y += vy * distanceAway;

    bullet = Bullet()
      ..position = position
      ..vx = -vx * moveSpeed
      ..vy = -vy * moveSpeed
      ..spriteFile = "assets/images/enemyShot1.png"
      ..width = 10
      ..height = 10
      ..angle = angle.toDouble() + radians(180);

    return bullet;
  }

  void create_astriod() {
    // add(astroid()
    //   ..position = Vector2(Random().nextInt(5) - 150, Random().nextInt(10) -150)
    //   ..vx = Random().nextDouble() * 2
    //   ..vy = Random().nextDouble() * 2);
    add(buildAsteroid());
    add(buildbullet());
    if (scoreBoard.score > 3) {
      double doom = scoreBoard.score / 4;
      for (int i = 0; i < doom; i++) {
        // add(astroid()
        //   ..position =
        //       Vector2(Random().nextInt(5) + 50, Random().nextInt(10) + 50)
        //   ..vx = Random().nextDouble() * 2
        //   ..vy = Random().nextDouble() * 2);
        add(buildAsteroid());
      }
    }
  }

  //Called every update with the deltatime between it and the last update
  @override
  void update(double dt) {
    super.update(dt);

    timer += dt;
    if (timer > timeToCreateAstroid) {
      create_astriod();
      timer = 0;
      print('Print');
    }
    //Just using this for the key inputs
    if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyA)) {
      player.left = true;
    } else {
      player.left = false;
    }
    if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyD)) {
      player.right = true;
    } else {
      player.right = false;
    }
    if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyW)) {
      player.up = true;
    } else {
      player.up = false;
    }
    if (RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.keyS)) {
      player.down = true;
    } else {
      player.down = false;
    }
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //This sets it up for mobile devices to be landscape and full screen
  Flame.device.setLandscape();
  Flame.device.fullScreen();

  //runApp(GameWidget(game: SpaceShooterGame()));
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: StartScreen(),
  ));
  //runApp(GameWidget(game: SpaceShooterGame()));
}
