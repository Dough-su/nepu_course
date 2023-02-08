class Player {
  final bool isHuman;
  final String name;

  Player(this.isHuman, this.name);

  Player.ai()
      : isHuman = false,
        name = "fear of Turing";

  Player.human()
      : isHuman = false,
        name = "player";
}
