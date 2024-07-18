import 'dart:async';

import 'package:fit_fighter/components/vaccine_component.dart';
import 'package:fit_fighter/components/virus_component.dart';
// import 'package:fit_fighter/components/virus_components.dart';
// import 'package:fit_fighter/components/virus_components.dart';
import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/games/dumbbell_dash_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class PlayerComponent extends SpriteComponent
    with HasGameRef<DumbbellDashGame>, CollisionCallbacks {
  final double _spriteHeight = 100;
  final double _speed = 500;

  JoystickComponent joystick;
  PlayerComponent({required this.joystick});

  late double _rightBound;
  late double _leftBound;
  late double _upBound;
  late double _downBound;

  late Sprite playerSkinny;
  late Sprite playerFever;
  late Sprite playerFit;
  late Sprite playerMuscular;
  bool _virusAttacked = false;
  final Timer _timer = Timer(1); // frozen for 3 seconds
  bool isVaccinated = false; // If player is vaccinated (immune to virus)

  void _freezePlayer() {
    if (!_virusAttacked) {
      FlameAudio.play(Globals.virusSound); // Play the sound at collsion
      _virusAttacked = true;
      playerSprite(); // Change the sprite image
      if (gameRef.score > 0) {
        gameRef.score -= 1;
      }
      _timer.start();
    }
  }

  void _unfreezePlayer() {
    _virusAttacked = false;
    playerSprite();
  }

  void playerSprite() {
    if (_virusAttacked) {
      sprite = playerFever;
    } else if (gameRef.score > 5 && gameRef.score <= 10) {
      sprite = playerFit;
    } else if (gameRef.score > 10) {
      sprite = playerMuscular;
    } else {
      sprite = playerSkinny;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_virusAttacked) {
      if (joystick.direction == JoystickDirection.idle) {
        return;
      }
      playerSprite();

      // If not idle then check not out of boundaries
      if (x >= _rightBound) {
        x = _rightBound;
      }
      if (x <= _leftBound) {
        x = _leftBound;
      }

      if (y <= _upBound) {
        y = _upBound;
      }
      if (y >= _downBound) {
        y = _downBound;
      }
      position.add(joystick.relativeDelta * _speed * dt);
    } else {
      _timer.update(dt);
      if (_timer.finished) {
        _unfreezePlayer();
      }
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    playerSkinny = await gameRef.loadSprite(Globals.playerSkinnySprite);
    playerFever = await gameRef.loadSprite(Globals.playerFeverSprite);
    playerFit = await gameRef.loadSprite(Globals.playerFitSprite);
    playerMuscular = await gameRef.loadSprite(Globals.playerMuscularSprite);

    playerSprite();
    position = gameRef.size / 2;
    height = width = _spriteHeight;
    anchor = Anchor.center;

    _rightBound = gameRef.size.x - 60;
    _leftBound = 60; // x started with 0
    _upBound = 60; // y started with 0
    _downBound = gameRef.size.y - 60;
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is VirusComponent) {
      if (!isVaccinated) {
        _freezePlayer();
      }
    }
    if (other is VaccineComponent) {
      injectVaccine();
    }
  }

  void injectVaccine() {
    // Dont execute if player is freezed by the virus
    if (!_virusAttacked) {
      isVaccinated = true;
      FlameAudio.play(Globals.vaccineSound);
      gameRef.vaccineTimer.start();
    }
  }

  void removeVaccine() {
    isVaccinated = false;
  }
}
