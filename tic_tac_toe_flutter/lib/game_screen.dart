import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/player.dart';
import 'package:tic_tac_toe_flutter/player_type.dart';
import 'package:tic_tac_toe_flutter/sign.dart';

import 'button.dart';
import 'game_mode.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.gameMode});

  final GameMode gameMode;

  @override
  State<StatefulWidget> createState() => GameState();
}

class GameState extends State<GameScreen> {
  late Player player1;
  late Player player2;
  bool gameHasWinner = false;
  String title = "Player 1 turn: X";
  Map<Button, Sign> gridMap = {};

  @override
  void initState() {
    super.initState();
    setupPlayers();
    setupGridMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.gameMode.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(
                            gridMap[Button.topLeft]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Button.topLeft);
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                            gridMap[Button.topMiddle]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Button.topMiddle);
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                            gridMap[Button.topRight]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Button.topRight);
                        },
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(
                            gridMap[Button.middleLeft]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Button.middleLeft);
                        },
                      ),
                      ElevatedButton(
                        child: Text(gridMap[Button.middleMiddle]?.text ??
                            Sign.none.text),
                        onPressed: () {
                          onButtonClick(Button.middleMiddle);
                        },
                      ),
                      ElevatedButton(
                        child: Text(gridMap[Button.middleRight]?.text ??
                            Sign.none.text),
                        onPressed: () {
                          onButtonClick(Button.middleRight);
                        },
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(
                            gridMap[Button.bottomLeft]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Button.bottomLeft);
                        },
                      ),
                      ElevatedButton(
                        child: Text(gridMap[Button.bottomMiddle]?.text ??
                            Sign.none.text),
                        onPressed: () {
                          onButtonClick(Button.bottomMiddle);
                        },
                      ),
                      ElevatedButton(
                        child: Text(gridMap[Button.bottomRight]?.text ??
                            Sign.none.text),
                        onPressed: () {
                          onButtonClick(Button.bottomRight);
                        },
                      ),
                    ]),
              ],
            ),
            Visibility(
              visible: gameHasWinner, // bool
              child: ElevatedButton(
                child: const Text("Rematch"),
                onPressed: () {
                  rematch();
                },
              ), // widget to show/hide
            ),
          ],
        ),
      ),
    );
  }

  void onButtonClick(Button button) {
    if (gameHasWinner) return;
    if (gridMap[button] != Sign.none) return;

    if (player1.hasTurn) {
      setState(() {
        player1.hasTurn = false;
        player2.hasTurn = true;
        title = "Player 2 turn: 0";
        gridMap[button] = player1.sign;
      });
    } else {
      setState(() {
        player1.hasTurn = true;
        player2.hasTurn = false;
        title = "Player 1 turn: X";
        gridMap[button] = player2.sign;
      });
    }
    checkForWin();
  }

  Button getAiEasyMove() {
    return Button.topLeft;
  }

  Button getAiEasyHard() {
    return Button.topLeft;
  }

  void checkForWin() {
    bool hasFirstRow = areEqual(gridMap[Button.topLeft],
        gridMap[Button.topMiddle], gridMap[Button.topRight]);

    bool hasSecondRow = areEqual(gridMap[Button.middleLeft],
        gridMap[Button.middleMiddle], gridMap[Button.middleRight]);

    bool hasThirdRow = areEqual(gridMap[Button.bottomLeft],
        gridMap[Button.bottomMiddle], gridMap[Button.bottomRight]);

    bool hasFirstColumn = areEqual(gridMap[Button.topLeft],
        gridMap[Button.middleLeft], gridMap[Button.bottomLeft]);

    bool hasSecondColumn = areEqual(gridMap[Button.topMiddle],
        gridMap[Button.middleMiddle], gridMap[Button.bottomMiddle]);

    bool hasThirdColumn = areEqual(gridMap[Button.topRight],
        gridMap[Button.middleRight], gridMap[Button.bottomRight]);

    bool hasMainDiagonal = areEqual(gridMap[Button.topLeft],
        gridMap[Button.middleMiddle], gridMap[Button.bottomRight]);

    bool hasSecondaryDiagonal = areEqual(gridMap[Button.topRight],
        gridMap[Button.middleMiddle], gridMap[Button.bottomLeft]);

    Sign winningSign = Sign.none;
    bool hasUnmarkedCells =
        gridMap.values.where((sign) => sign == Sign.none).isNotEmpty;

    if (hasFirstRow || hasFirstColumn || hasMainDiagonal) {
      winningSign = gridMap[Button.topLeft] ?? Sign.none;
    } else if (hasSecondRow || hasSecondColumn || hasSecondaryDiagonal) {
      winningSign = gridMap[Button.middleMiddle] ?? Sign.none;
    } else if (hasThirdRow || hasThirdColumn) {
      winningSign = gridMap[Button.bottomRight] ?? Sign.none;
    }

    if (winningSign == player1.sign) {
      setState(() {
        title = "Player 1 wins!";
        gameHasWinner = true;
      });
    } else if (winningSign == player2.sign) {
      setState(() {
        title = "Player 2 wins!";
        gameHasWinner = true;
      });
    } else if (!hasUnmarkedCells) {
      setState(() {
        title = "Draw!";
        gameHasWinner = true;
      });
    }
  }

  void rematch() {
    setupPlayers();
    setupGridMap();
    setState(() {
      gameHasWinner = false;
      title = "Player 1 turn: X";
    });
  }

  void setupPlayers() {
    setState(() {
      switch (widget.gameMode) {
        case GameMode.twoPlayers:
          player1 = Player(hasTurn: true, sign: Sign.x);
          player2 = Player(sign: Sign.o);
          break;
        case GameMode.onePlayerWithAiEasy:
          player1 = Player(hasTurn: true, sign: Sign.x);
          player2 = Player(type: PlayerType.aiEasy, sign: Sign.o);
          break;
        case GameMode.onePlayerWithAiHard:
          player1 = Player(hasTurn: true, sign: Sign.x);
          player2 = Player(type: PlayerType.aiHard, sign: Sign.o);
          break;
      }
    });
  }

  void setupGridMap() {
    setState(() {
      gridMap = {
        Button.topLeft: Sign.none,
        Button.topMiddle: Sign.none,
        Button.topRight: Sign.none,
        Button.middleLeft: Sign.none,
        Button.middleMiddle: Sign.none,
        Button.middleRight: Sign.none,
        Button.bottomLeft: Sign.none,
        Button.bottomMiddle: Sign.none,
        Button.bottomRight: Sign.none
      };
    });
  }

  bool areEqual(Sign? value1, Sign? value2, Sign? value3) {
    return value1 != Sign.none && value1 == value2 && value2 == value3;
  }
}
