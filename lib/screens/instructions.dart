import 'package:flutter/material.dart';
import 'package:fit_fighter/constants/globals.dart';

class InstructionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/${Globals.backgroundSprite}"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9), // Semi-transparent white background
              borderRadius: BorderRadius.circular(20.0),
            ),
            constraints: BoxConstraints(maxWidth: 600), // Limit width for larger screens
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Objective:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Collect as many dumbbells as possible to increase your score within a 30-second time limit.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInstructionItem(
                    title: 'Collect Dumbbells:',
                    content:
                        'Each dumbbell you collect increases your score by 1 point.',
                  ),
                  _buildInstructionItem(
                    title: 'Dodge Viruses:',
                    content:
                        'Avoid colliding with viruses on the screen.\nColliding with a virus will decrease your score by 1 point and freeze the player for 1 second (resulting in a "fever").',
                  ),
                  _buildInstructionItem(
                    title: 'Take the Vaccine:',
                    content:
                        'Collect vaccines that appear on the screen to become immune to viruses for 4 seconds.',
                  ),
                  _buildInstructionItem(
                    title: 'Collect Protein:',
                    content:
                        'Randomly appearing protein increases your score by a random value between 1 and 8 points.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
