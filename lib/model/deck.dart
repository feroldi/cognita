class Deck {
  int id;
  String title;
  int maxGroup;

  Deck(this.id, this.title, this.maxGroup);

  Deck copyWith({int id, String title, int maxGroup}) =>
      Deck(
        id ?? this.id,
        title ?? this.title,
        maxGroup ?? this.maxGroup,
      );
}
