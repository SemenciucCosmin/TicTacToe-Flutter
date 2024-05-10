import 'package:tic_tac_toe_flutter/player_type.dart';
import 'package:tic_tac_toe_flutter/sign.dart';

class Player {
  bool hasTurn;
  PlayerType type;
  Sign sign;

  Player(
      {this.hasTurn = false, this.type = PlayerType.human, required this.sign});
}
