import 'dart:async';

import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/games/dumbbell_dash_game.dart';
import 'package:flame/components.dart';

class BackgroundComponent extends SpriteComponent
    with HasGameRef<DumbbellDashGame> {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite(Globals.backgroundSprite);
    size = gameRef.size;
  }
}
