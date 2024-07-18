import 'dart:async';
import 'dart:math';

import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/games/dumbbell_dash_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class VirusComponent extends SpriteComponent
    with HasGameRef<DumbbellDashGame>, CollisionCallbacks {
  final double _spriteHeight = 60;
  final Vector2 startPosition;

  VirusComponent({required this.startPosition});

  late Vector2 _velocity;
  double speed = 300;

  Vector2 moveSprite() {
    // Generate a random angle in radians
    final randomAngle = Random().nextDouble() * 2 * pi;
    // calculate the sine and cosine of the angle
    final sinAngle = sin(randomAngle);
    final cosAngle = cos(randomAngle);

    final double vx = cosAngle * speed;
    final double vy = sinAngle * speed;
    return Vector2(vx, vy);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite(Globals.virusSprite);
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

    // Check for screen boundaries and reverse direction if necessary
    if (position.x - _spriteHeight / 2 <= 0) {
      position.x = _spriteHeight / 2; // Move slightly away from the edge
      _velocity.x = -_velocity.x;
    } else if (position.x + _spriteHeight / 2 >= gameRef.size.x) {
      position.x = gameRef.size.x - _spriteHeight / 2; // Move slightly away from the edge
      _velocity.x = -_velocity.x;
    }

    if (position.y - _spriteHeight / 2 <= 0) {
      position.y = _spriteHeight / 2; // Move slightly away from the edge
      _velocity.y = -_velocity.y;
    } else if (position.y + _spriteHeight / 2 >= gameRef.size.y) {
      position.y = gameRef.size.y - _spriteHeight / 2; // Move slightly away from the edge
      _velocity.y = -_velocity.y;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ScreenHitbox) {
      final Vector2 collisionpoint = intersectionPoints.first;
      if (collisionpoint.x <= 0 || collisionpoint.x >= gameRef.size.x) {
        _velocity.x = -_velocity.x;
      }

      if (collisionpoint.y <= 0 || collisionpoint.y >= gameRef.size.y) {
        _velocity.y = -_velocity.y;
      }
    }
  }
}
