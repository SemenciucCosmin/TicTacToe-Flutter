import 'package:flutter/material.dart';

import 'game_mode.dart';
import 'game_screen.dart';

class GameModeScreen extends StatelessWidget {
  const GameModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Game Mode Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Choose the game mode",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: Text(GameMode.twoPlayers.title),
              onPressed: () {
                _onGameModeSelected(context, GameMode.twoPlayers);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: Text(GameMode.onePlayerWithAiEasy.title),
              onPressed: () {
                _onGameModeSelected(context, GameMode.onePlayerWithAiEasy);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: Text(GameMode.onePlayerWithAiHard.title),
              onPressed: () {
                _onGameModeSelected(context, GameMode.onePlayerWithAiHard);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onGameModeSelected(BuildContext context, GameMode gameMode) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GameScreen(gameMode: gameMode)));
  }
}
