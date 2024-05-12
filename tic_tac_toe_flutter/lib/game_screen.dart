import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/game_status.dart';
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
  GameStatus gameStatus = Ongoing();
  String title = "";
  Map<Button, Sign> gridMap = {};

  @override
  void initState() {
    super.initState();
    setupGameStatus(gameStatus);
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
              visible: gameStatus is! Ongoing, // bool
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
    if (gameStatus is Win) return;
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

    setupGameStatus(getGameStatus(gridMap));
  }

  Button getAiEasyMove() {
    return Button.topLeft;
  }

  Button getAiEasyHard() {
    return Button.topLeft;
  }

  GameStatus getGameStatus(Map<Button, Sign> map) {
    bool hasFirstRow = areEqual(
        map[Button.topLeft], map[Button.topMiddle], map[Button.topRight]);

    bool hasSecondRow = areEqual(map[Button.middleLeft],
        map[Button.middleMiddle], map[Button.middleRight]);

    bool hasThirdRow = areEqual(map[Button.bottomLeft],
        map[Button.bottomMiddle], map[Button.bottomRight]);

    bool hasFirstColumn = areEqual(
        map[Button.topLeft], map[Button.middleLeft], map[Button.bottomLeft]);

    bool hasSecondColumn = areEqual(map[Button.topMiddle],
        map[Button.middleMiddle], map[Button.bottomMiddle]);

    bool hasThirdColumn = areEqual(
        map[Button.topRight], map[Button.middleRight], map[Button.bottomRight]);

    bool hasMainDiagonal = areEqual(
        map[Button.topLeft], map[Button.middleMiddle], map[Button.bottomRight]);

    bool hasSecondaryDiagonal = areEqual(
        map[Button.topRight], map[Button.middleMiddle], map[Button.bottomLeft]);

    bool hasUnmarkedCells =
        map.values.where((sign) => sign == Sign.none).isNotEmpty;

    Sign winningSign = Sign.none;

    if (hasFirstRow || hasFirstColumn || hasMainDiagonal) {
      winningSign = map[Button.topLeft] ?? Sign.none;
    } else if (hasSecondRow || hasSecondColumn || hasSecondaryDiagonal) {
      winningSign = map[Button.middleMiddle] ?? Sign.none;
    } else if (hasThirdRow || hasThirdColumn) {
      winningSign = map[Button.bottomRight] ?? Sign.none;
    }

    if (winningSign != Sign.none) {
      return Win(winningSign);
    } else if (!hasUnmarkedCells) {
      return Draw();
    } else {
      return Ongoing();
    }
  }

  void rematch() {
    setupPlayers();
    setupGridMap();
    setState(() {
      gameStatus = Ongoing();
    });
  }

  void setupGameStatus(GameStatus status) {
    setState(() {
      gameStatus = status;

      switch (status) {
        case Draw():
          title = "Draw!";
          break;
        case Ongoing():
          if (player1.hasTurn) {
            title = "Player 1 turn: ${player1.sign}";
          } else {
            title = "Player 1 turn: ${player2.sign}";
          }
          break;
        case Win():
          if (status.playerSign == player1.sign) {
            title = "Player 1 won!";
          } else {
            title = "Player 2 won!";
          }
          break;
      }
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
