import 'package:tic_tac_toe_flutter/sign.dart';

sealed class GameStatus {}

class Draw extends GameStatus {}

class Ongoing extends GameStatus {}

class Win extends GameStatus {
  final Sign playerSign;

  Win(this.playerSign);
}
