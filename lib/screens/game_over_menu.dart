import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/games/dumbbell_dash_game.dart';
import 'package:fit_fighter/screens/main_menu.dart';
import 'package:flutter/material.dart';

class GameOverMenu extends StatelessWidget {
  static const String ID = "GameOverMenu";

  final DumbbellDashGame gameRef;
  const GameOverMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/${Globals.backgroundSprite}"),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Game Over",
                style: TextStyle(fontSize: 50),
              ),
              Text(
                "Score: ${gameRef.score}",
                style: const TextStyle(fontSize: 50),
              ),
              Text(
                "(Protein Bonus: ${gameRef.proteinBonus})",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 200,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    gameRef.overlays.remove(GameOverMenu.ID);
                    gameRef.reset();
                    gameRef.resumeEngine();
                  },
                  child: const Text(
                    "Play Again ?",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    gameRef.overlays.remove(GameOverMenu.ID);
                    gameRef.reset();
                    gameRef.resumeEngine();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainMenu()));
                  },
                  child: const Text(
                    "Main Menu",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
