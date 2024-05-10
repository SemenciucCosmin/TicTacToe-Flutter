enum GameMode {
  twoPlayers("Two players"),
  onePlayerWithAiEasy("One player with AI: easy"),
  onePlayerWithAiHard("One player with AI: hard");

  const GameMode(this.title);

  final String title;
}
