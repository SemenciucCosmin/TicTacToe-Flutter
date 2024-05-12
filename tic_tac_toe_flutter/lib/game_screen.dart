import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/game_status.dart';
import 'package:tic_tac_toe_flutter/player.dart';
import 'package:tic_tac_toe_flutter/player_type.dart';
import 'package:tic_tac_toe_flutter/sign.dart';

import 'cell.dart';
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
  Map<Cell, Sign> gridMap = {};

  @override
  void initState() {
    super.initState();
    setupPlayers();
    setupGridMap();
    setupGameStatus(gameStatus);
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
                        child:
                            Text(gridMap[Cell.topLeft]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Cell.topLeft);
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                            gridMap[Cell.topMiddle]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Cell.topMiddle);
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                            gridMap[Cell.topRight]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Cell.topRight);
                        },
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(
                            gridMap[Cell.middleLeft]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Cell.middleLeft);
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                            gridMap[Cell.middleMiddle]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Cell.middleMiddle);
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                            gridMap[Cell.middleRight]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Cell.middleRight);
                        },
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(
                            gridMap[Cell.bottomLeft]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Cell.bottomLeft);
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                            gridMap[Cell.bottomMiddle]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Cell.bottomMiddle);
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                            gridMap[Cell.bottomRight]?.text ?? Sign.none.text),
                        onPressed: () {
                          onButtonClick(Cell.bottomRight);
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

  void onButtonClick(Cell cell) {
    if (gameStatus is! Ongoing) return;
    if (gridMap[cell] != Sign.none) return;

    switch (widget.gameMode) {
      case GameMode.twoPlayers:
        if (player1.hasTurn) {
          markCell(cell, player1.sign);
        } else {
          markCell(cell, player2.sign);
        }
        changePlayersTurns();
        break;

      case GameMode.onePlayerWithAiEasy:
        // Make sure user does not click a cell while the AI is computing a move
        if (player1.hasTurn) {
          markCell(cell, player1.sign);
          changePlayersTurns();
          setupGameStatus(getGameStatus(gridMap));

          // Prevent th AI from marking its move if the user has already won
          if (getGameStatus(gridMap) is! Ongoing) return;

          // Mark the AI-easy move after a two seconds delay to
          // simulate computing algorithm
          Future.delayed(const Duration(seconds: 2), () {
            markCell(getAiEasyMove(), player2.sign);
            changePlayersTurns();
            setupGameStatus(getGameStatus(gridMap));
          });
        }
        break;

      case GameMode.onePlayerWithAiHard:
        // Make sure user does not click a cell while the AI is computing a move
        if (player1.hasTurn) {
          markCell(cell, player1.sign);
          changePlayersTurns();
          setupGameStatus(getGameStatus(gridMap));

          // Prevent th AI from marking its move if the user has already won
          if (getGameStatus(gridMap) is! Ongoing) return;

          Future.delayed(const Duration(seconds: 2), () {
            markCell(getAiHardMove(), player2.sign);
            changePlayersTurns();
            setupGameStatus(getGameStatus(gridMap));
          });
        }
        break;
    }
  }

  Cell getAiEasyMove() {
    List<Cell> emptyCells =
        gridMap.keys.where((cell) => gridMap[cell] == Sign.none).toList();
    final random = Random();
    return emptyCells[random.nextInt(emptyCells.length)];
  }

  Cell getAiHardMove() {
    return Cell.topLeft;
  }

  GameStatus getGameStatus(Map<Cell, Sign> map) {
    bool hasFirstRow =
        areEqual(map[Cell.topLeft], map[Cell.topMiddle], map[Cell.topRight]);

    bool hasSecondRow = areEqual(
        map[Cell.middleLeft], map[Cell.middleMiddle], map[Cell.middleRight]);

    bool hasThirdRow = areEqual(
        map[Cell.bottomLeft], map[Cell.bottomMiddle], map[Cell.bottomRight]);

    bool hasFirstColumn =
        areEqual(map[Cell.topLeft], map[Cell.middleLeft], map[Cell.bottomLeft]);

    bool hasSecondColumn = areEqual(
        map[Cell.topMiddle], map[Cell.middleMiddle], map[Cell.bottomMiddle]);

    bool hasThirdColumn = areEqual(
        map[Cell.topRight], map[Cell.middleRight], map[Cell.bottomRight]);

    bool hasMainDiagonal = areEqual(
        map[Cell.topLeft], map[Cell.middleMiddle], map[Cell.bottomRight]);

    bool hasSecondaryDiagonal = areEqual(
        map[Cell.topRight], map[Cell.middleMiddle], map[Cell.bottomLeft]);

    bool hasUnmarkedCells =
        map.values.where((sign) => sign == Sign.none).isNotEmpty;

    Sign winningSign = Sign.none;

    if (hasFirstRow || hasFirstColumn || hasMainDiagonal) {
      winningSign = map[Cell.topLeft] ?? Sign.none;
    } else if (hasSecondRow || hasSecondColumn || hasSecondaryDiagonal) {
      winningSign = map[Cell.middleMiddle] ?? Sign.none;
    } else if (hasThirdRow || hasThirdColumn) {
      winningSign = map[Cell.bottomRight] ?? Sign.none;
    }

    if (winningSign != Sign.none) {
      return Win(winningSign);
    } else if (!hasUnmarkedCells) {
      return Draw();
    } else {
      return Ongoing();
    }
  }

  void changePlayersTurns() {
    setState(() {
      player1.hasTurn = !player1.hasTurn;
      player2.hasTurn = !player2.hasTurn;
    });
  }

  void markCell(Cell cell, Sign sign) {
    setState(() {
      gridMap[cell] = sign;
    });
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
            title = "Player 1 turn: ${player1.sign.text}";
          } else {
            title = "Player 2 turn: ${player2.sign.text}";
          }
          break;
        case Win():
          if (status.playerSign == player1.sign) {
            title = "Player 1 wins!";
          } else {
            title = "Player 2 wins!";
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
        Cell.topLeft: Sign.none,
        Cell.topMiddle: Sign.none,
        Cell.topRight: Sign.none,
        Cell.middleLeft: Sign.none,
        Cell.middleMiddle: Sign.none,
        Cell.middleRight: Sign.none,
        Cell.bottomLeft: Sign.none,
        Cell.bottomMiddle: Sign.none,
        Cell.bottomRight: Sign.none
      };
    });
  }

  bool areEqual(Sign? value1, Sign? value2, Sign? value3) {
    return value1 != Sign.none && value1 == value2 && value2 == value3;
  }
}
