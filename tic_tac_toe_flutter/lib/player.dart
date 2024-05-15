import 'package:tic_tac_toe_flutter/sign.dart';

class Player {
  bool hasTurn;
  Sign sign;

  Player(
      {this.hasTurn = false, required this.sign});
}
