import 'dart:async';
import 'dart:math';

import 'package:fit_fighter/components/player_component.dart';
import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/games/dumbbell_dash_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class DumbbellComponent extends SpriteComponent
    with HasGameRef<DumbbellDashGame>, CollisionCallbacks {
  final double _spriteHeight = 60;

  final Random _random = Random();

  Vector2 _getRandomPosition() {// random position generator method 
    double x = _random.nextInt(gameRef.size.x.toInt()).toDouble();
    double y = _random.nextInt(gameRef.size.y.toInt()).toDouble();
    return Vector2(x, y);
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite(Globals.dumbbellSprite);
    height = width = _spriteHeight;
    position = _getRandomPosition(); // random position
    anchor = Anchor.center;
    add(RectangleHitbox()); // add hitbox for collision detection
    // debugMode = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is PlayerComponent) {
      FlameAudio.play(Globals.dumbbellSound);
      removeFromParent();   // remove the dumbbell
      gameRef.score += 1;    // increase the score
      gameRef.add(DumbbellComponent()); // add another dumbbell
    }
  }
}
