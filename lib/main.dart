// import 'package:fit_fighter/games/dumbbell_dash_game.dart';
import 'package:fit_fighter/screens/game_splash_screen.dart';
// import 'package:fit_fighter/screens/main_menu.dart';
import 'package:flutter/material.dart';
// import 'package:flame/game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameSplashScreen(),
    ),
  );
}
