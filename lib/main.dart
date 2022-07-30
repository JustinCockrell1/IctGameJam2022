
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'package:flame/game.dart';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:gamejam/classes/ScoreBoard.dart';

import 'classes/Spaceship.dart';
import 'classes/Background.dart';

import 'classes/Endpoint.dart';


class SpaceShooterGame extends FlameGame with HasCollisionDetection {

  //Declare variables
  late SpaceShip player;
  late EndPoint endPoint;
  Scoreboard scoreBoard = Scoreboard();
  bool left = false, right = false, up = false, down = false;

  Background _background = Background();


  //Sets it to debug mode or not - makes it display the hit boxes and coordinates
  @override
  bool get debugMode => true;


  //Increase the display on the scoreboard
  void increaseScore() {
    scoreBoard.score++;
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
      ..anchor=Anchor.center;

  //Add the components into the game
    add(ScreenHitbox());
    add(player);
    add(endPoint);
    add(scoreBoard);

    //  camera.followComponent(player);
  }

  //Called every update with the deltatime between it and the last update
  @override
  void update(double dt) {

   
    super.update(dt);
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
  runApp(GameWidget(game: SpaceShooterGame()));
}