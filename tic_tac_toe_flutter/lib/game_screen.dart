import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/game_status.dart';
import 'package:tic_tac_toe_flutter/grid.dart';
import 'package:tic_tac_toe_flutter/player.dart';
import 'package:tic_tac_toe_flutter/sign.dart';

import 'cell.dart';
import 'game_mode.dart';

const int lastIteration = 0;
const int winPoints = 100;
const int drawPoints = 25;
const int neutralPoints = 0;
const int aiIterations = 5;

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.gameMode});

  final GameMode gameMode;

  @override
  State<StatefulWidget> createState() => GameState();
}

class GameState extends State<GameScreen> {
  Player player1 = Player(hasTurn: true, sign: Sign.x);
  Player player2 = Player(sign: Sign.o);
  Grid grid = Grid();
  GameStatus gameStatus = Ongoing();
  String title = "";

  @override
  void initState() {
    super.initState();
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
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(grid.getCellSignText(Cell.topLeft)),
                        onPressed: () {
                          onButtonClick(Cell.topLeft);
                        },
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        child: Text(grid.getCellSignText(Cell.topMiddle)),
                        onPressed: () {
                          onButtonClick(Cell.topMiddle);
                        },
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        child: Text(grid.getCellSignText(Cell.topRight)),
                        onPressed: () {
                          onButtonClick(Cell.topRight);
                        },
                      ),
                    ]),
                const SizedBox(width: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(grid.getCellSignText(Cell.middleLeft)),
                        onPressed: () {
                          onButtonClick(Cell.middleLeft);
                        },
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        child: Text(grid.getCellSignText(Cell.middleMiddle)),
                        onPressed: () {
                          onButtonClick(Cell.middleMiddle);
                        },
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        child: Text(grid.getCellSignText(Cell.middleRight)),
                        onPressed: () {
                          onButtonClick(Cell.middleRight);
                        },
                      ),
                    ]),
                const SizedBox(width: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(grid.getCellSignText(Cell.bottomLeft)),
                        onPressed: () {
                          onButtonClick(Cell.bottomLeft);
                        },
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        child: Text(grid.getCellSignText(Cell.bottomMiddle)),
                        onPressed: () {
                          onButtonClick(Cell.bottomMiddle);
                        },
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        child: Text(grid.getCellSignText(Cell.bottomRight)),
                        onPressed: () {
                          onButtonClick(Cell.bottomRight);
                        },
                      ),
                    ]),
              ],
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: widget.gameMode != GameMode.twoPlayers &&
                  player2.hasTurn &&
                  gameStatus is Ongoing, // bool
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Computing AI move"),
                  SizedBox(width: 16),
                  SizedBox(
                    height: 15.0,
                    width: 15.0,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
    if (!grid.isCellEmpty(cell)) return;

    switch (widget.gameMode) {
      case GameMode.twoPlayers:
        makePlayerMove(cell);
        break;

      default:
        // Make sure user does not click a cell while the AI is computing a move
        if (player2.hasTurn) return;

        makePlayerMove(cell);

        // Prevent th AI from marking its move if the user has already won
        if (grid.getGameStatus() is! Ongoing) return;

        // Mark the AI-easy move after a two seconds delay to
        // simulate computing algorithm
        Future.delayed(const Duration(seconds: 2), () {
          makeAiMove();
        });

        break;
    }
  }

  void makePlayerMove(Cell cell) {
    if (player1.hasTurn) {
      grid.markCell(cell, player1.sign);
    } else {
      grid.markCell(cell, player2.sign);
    }

    changePlayersTurns();
    setupGameStatus(grid.getGameStatus());
  }

  void makeAiMove() {
    if (widget.gameMode == GameMode.onePlayerWithAiEasy) {
      grid.markCell(getAiEasyMove(), player2.sign);
    } else {
      grid.markCell(getAiHardMove(), player2.sign);
    }

    changePlayersTurns();
    setupGameStatus(grid.getGameStatus());
  }

  Cell getAiEasyMove() {
    List<Cell> emptyCells = grid.getEmptyCells();
    final random = Random();
    return emptyCells[random.nextInt(emptyCells.length)];
  }

  Cell getAiHardMove() {
    List<Cell> emptyCells = grid.getEmptyCells();
    Map<Cell, int> cellPoints = {};

    for (var cell in emptyCells) {
      Grid newGrid = grid.getCopy();
      newGrid.markCell(cell, player2.sign);
      cellPoints[cell] = getPoints(newGrid, player1, aiIterations);
    }

    int maxPoints = neutralPoints;
    Cell selectedCell = cellPoints.keys.first;

    cellPoints.forEach((cell, points) {
      if (points > maxPoints) {
        maxPoints = points;
        selectedCell = cell;
      }
    });

    return selectedCell;
  }

  void changePlayersTurns() {
    setState(() {
      player1.hasTurn = !player1.hasTurn;
      player2.hasTurn = !player2.hasTurn;
    });
  }

  void rematch() {
    grid.reset();
    setState(() {
      gameStatus = Ongoing();
      player1 = Player(hasTurn: true, sign: Sign.x);
      player2 = Player(sign: Sign.o);
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

  int getPoints(Grid grid, Player player, int iterationIndex) {
    int points = neutralPoints;
    GameStatus gameStatus = grid.getGameStatus();

    switch (gameStatus) {
      case Draw():
        points = drawPoints;
        break;

      case Win():
        if (gameStatus.playerSign == player2.sign) {
          points = winPoints;
        }
        break;
      case Ongoing():
        if (iterationIndex == lastIteration) break;
        List<Cell> emptyCells = grid.getEmptyCells();
        Map<Cell, int> cellPoints = {};

        for (var cell in emptyCells) {
          Grid newGrid = grid.getCopy();
          newGrid.markCell(cell, player.sign);
          if (player.sign == player1.sign) {
            cellPoints[cell] = getPoints(newGrid, player2, iterationIndex - 1);
          } else {
            cellPoints[cell] = getPoints(newGrid, player1, iterationIndex - 1);
          }
        }

        points = cellPoints.values.reduce((sum, element) => sum + element);
        break;
    }

    return points;
  }
}
