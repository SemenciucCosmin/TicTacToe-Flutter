import 'package:tic_tac_toe_flutter/sign.dart';

import 'cell.dart';
import 'game_status.dart';

class Grid {
  Map<Cell, Sign> map = {
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

  String getCellSignText(Cell cell) {
    return map[cell]?.text ?? Sign.none.text;
  }

  bool isCellEmpty(Cell cell) {
    return map[cell] == Sign.none;
  }

  void markCell(Cell cell, Sign sign) {
    map[cell] = sign;
  }

  List<Cell> getEmptyCells() {
    return map.keys.where((cell) => isCellEmpty(cell)).toList();
  }

  GameStatus getGameStatus() {
    bool hasFirstRow =
        _areEqual(map[Cell.topLeft], map[Cell.topMiddle], map[Cell.topRight]);

    bool hasSecondRow = _areEqual(
        map[Cell.middleLeft], map[Cell.middleMiddle], map[Cell.middleRight]);

    bool hasThirdRow = _areEqual(
        map[Cell.bottomLeft], map[Cell.bottomMiddle], map[Cell.bottomRight]);

    bool hasFirstColumn = _areEqual(
        map[Cell.topLeft], map[Cell.middleLeft], map[Cell.bottomLeft]);

    bool hasSecondColumn = _areEqual(
        map[Cell.topMiddle], map[Cell.middleMiddle], map[Cell.bottomMiddle]);

    bool hasThirdColumn = _areEqual(
        map[Cell.topRight], map[Cell.middleRight], map[Cell.bottomRight]);

    bool hasMainDiagonal = _areEqual(
        map[Cell.topLeft], map[Cell.middleMiddle], map[Cell.bottomRight]);

    bool hasSecondaryDiagonal = _areEqual(
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

  void reset() {
    map = {
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
  }

  bool _areEqual(Sign? value1, Sign? value2, Sign? value3) {
    return value1 != Sign.none && value1 == value2 && value2 == value3;
  }

  Grid getCopy() {
    Grid copy = Grid();

    for (var element in map.entries) {
      copy.markCell(element.key, element.value);
    }

    return copy;
  }
}
