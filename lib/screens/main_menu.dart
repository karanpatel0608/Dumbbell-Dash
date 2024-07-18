import 'package:flutter/material.dart';
import 'package:fit_fighter/constants/globals.dart';
import 'package:fit_fighter/screens/game_play.dart';
import 'package:fit_fighter/screens/instructions.dart'; // Import InstructionsPage

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/${Globals.backgroundSprite}"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  "Dumbbell Dash",
                  style: TextStyle(fontSize: 50),
                ),
              ),
              const SizedBox(
                height: 200,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const GamePlay()),
                    );
                  },
                  child: const Text(
                    "Play",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 20, // Adjust spacing between buttons
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => InstructionsPage()),
                    );
                  },
                  child: const Text(
                    "Instructions",
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
