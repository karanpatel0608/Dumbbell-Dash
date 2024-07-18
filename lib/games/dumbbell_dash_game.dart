import 'dart:async';
import 'dart:math';

import 'package:fit_fighter/components/background_component.dart';
import 'package:fit_fighter/components/dumbbell_component.dart';
import 'package:fit_fighter/components/player_component.dart';
import 'package:fit_fighter/components/protein_component.dart';
import 'package:fit_fighter/components/vaccine_component.dart';
import 'package:fit_fighter/components/virus_component.dart';
// import 'package:fit_fighter/components/virus_component.dart';
// import 'package:fit_fighter/components/virus_components.dart';
import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/inputs/joystick.dart';
import 'package:fit_fighter/screens/game_over_menu.dart';
// import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';

class DumbbellDashGame extends FlameGame
    with HasCollisionDetection {
  int score = 0;
  late Timer _timer;
  int _remainingTime = 30;
  late TextComponent _scoreText;
  late TextComponent _timeText;
  late PlayerComponent playerComponent;
  final VaccineComponent _vaccineComponent =
      VaccineComponent(startPosition: Vector2(200, 200));
  int _vaccineImmunityTime = 4; // Vaccine will give immunity only for 4 seconds
  late Timer vaccineTimer; // Timer Object
  late int _vaccineTimerAppearance; // Random Time for the vaccine to appear

  // Protein Component
  final ProteinComponent _proteinComponent =
      ProteinComponent(startPosition: Vector2(200, 400));
  int _proteinTimeLeft =
      4; // Protein will automaticallyy disappear after 4 seconds
  late Timer proteinTimer;
  late int _proteinTimeAppearance; // Random Time for the protein to appear
  int proteinBonus = 0; // Keep track of any bonus

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _vaccineTimerAppearance =
        Random().nextInt(_remainingTime - 20) + 20; // First vaccine to appear
    _proteinTimeAppearance = Random().nextInt(_remainingTime - 5) +
        5; // Time should be greater than 5 sec and less than 30 secs
    add(BackgroundComponent());
    playerComponent = PlayerComponent(joystick: joystick);
    add(playerComponent);
    add(DumbbellComponent());
    add(joystick);

    FlameAudio.audioCache.loadAll([
      Globals.dumbbellSound,
      Globals.virusSound,
      Globals.vaccineSound,
      Globals.proteinSound,
    ]);

    add(VirusComponent(startPosition: Vector2(100, 150)));
    add(VirusComponent(startPosition: Vector2(size.x - 50, size.y - 200)));
    // Any collision on the bounds of the view port
    add(ScreenHitbox());

    _timer = Timer(1, repeat: true, onTick: () {
      if (_remainingTime == 0) {
        pauseEngine();
        overlays.add(GameOverMenu.ID);
      } else if (_remainingTime == _vaccineTimerAppearance) {
        add(_vaccineComponent);
      } else if (_remainingTime == _proteinTimeAppearance) {
        add(_proteinComponent);
        proteinTimer.start();
      }
      _remainingTime -= 1;
    });

    _timer.start();

    proteinTimer = Timer(1, repeat: true, onTick: () {
      if (_proteinTimeLeft == 0) {
        remove(_proteinComponent);
        _proteinTimeLeft = 4;
        proteinTimer.stop();
      } else {
        _proteinTimeLeft -= 1;
      }
    });

    vaccineTimer = Timer(1, repeat: true, onTick: () {
      if (_vaccineImmunityTime == 0) {
        playerComponent
            .removeVaccine(); // call the remove vaccine function in the player class
        _vaccineImmunityTime = 4; // Again set the immunity time to 4
        _vaccineTimerAppearance = 0;
        vaccineTimer.stop();
      } else {
        _vaccineImmunityTime -= 1;
      }
    });

    _scoreText = TextComponent(
        text: "Score: $score",
        position: Vector2(40, 40),
        anchor: Anchor.topLeft,
        textRenderer: TextPaint(
            style: TextStyle(color: BasicPalette.black.color, fontSize: 25)));

    add(_scoreText);

    _timeText = TextComponent(
        text: "Time: $_remainingTime secs",
        position: Vector2(size.x - 40, 40),
        anchor: Anchor.topRight,
        textRenderer: TextPaint(
            style: TextStyle(
          color: BasicPalette.black.color,
          fontSize: 25,
        )));

    add(_timeText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_proteinComponent.isLoaded) {
      proteinTimer.update(dt);
    }
    _timer.update(dt);
    _scoreText.text = "Score: $score";
    _timeText.text = "Time: $_remainingTime secs";

    if (playerComponent.isVaccinated) {
      vaccineTimer.update(dt);
    } else if (_vaccineTimerAppearance == 0) {
      if (_remainingTime > 3) {
        _vaccineTimerAppearance = Random().nextInt(_remainingTime - 3) +
            3; // New vaccine appearance time
      }
    }
  }

  void reset() async {
    score = 0;
    _remainingTime = 30;
    _vaccineImmunityTime = 4;
    _vaccineComponent.removeFromParent();
    _proteinTimeLeft = 4;
    _proteinComponent.removeFromParent();
    _proteinTimeAppearance = Random().nextInt(_remainingTime - 5) + 5;
    playerComponent.sprite = await loadSprite(Globals.playerSkinnySprite);
  }
}
