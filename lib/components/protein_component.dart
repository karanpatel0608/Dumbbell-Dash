import 'dart:async';
import 'dart:math';

import 'package:fit_fighter/components/player_component.dart';
import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/games/dumbbell_dash_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class ProteinComponent extends SpriteComponent
    with HasGameRef<DumbbellDashGame>, CollisionCallbacks {
  final double _spriteHeight = 60;
  final Vector2 startPosition;

  ProteinComponent({required this.startPosition});

  late Vector2 _velocity;
  double speed = 300;

  Vector2 moveSprite() {
    // Generate a random angle in radians
    final randomAngle = Random().nextDouble() * 2 * pi;
    // calculate the sine and cosinne of the angle
    final sinAngle = sin(randomAngle);
    final cosAngle = cos(randomAngle);

    final double vx = cosAngle * speed;
    final double vy = sinAngle * speed;
    return Vector2(vx, vy);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Globals.proteinSprite);
    position = startPosition;
    width = height = _spriteHeight;
    anchor = Anchor.center;
    _velocity = moveSprite();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ScreenHitbox) {
      final Vector2 collisionpoint = intersectionPoints.first;
      if (collisionpoint.x == 0) {
        // at the very left
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      if (collisionpoint.x >= gameRef.size.x - 60) {
        // at the very right
        _velocity.x = -_velocity.x;
        _velocity.y = _velocity.y;
      }
      if (collisionpoint.y == 0) {
        // at the very top
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
      if (collisionpoint.y >= gameRef.size.y-60) {
        // at the very bottom
        _velocity.x = _velocity.x;
        _velocity.y = -_velocity.y;
      }
    }
    if (other is PlayerComponent) {
      removeFromParent();
      int randomBonusScore = Random().nextInt(9); // from 0 to 8
      gameRef.score += randomBonusScore;
      FlameAudio.play(Globals.proteinSound);
      gameRef.proteinTimer.stop();
      gameRef.proteinBonus = randomBonusScore;
    }
  }
}
