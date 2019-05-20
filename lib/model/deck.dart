class Deck {
  int id;
  String title;
  int maxGroup;

  Deck(this.id, this.title, this.maxGroup);

  Deck copyWith({int id, String title, int maxGroup}) => Deck(
        id ?? this.id,
        title ?? this.title,
        maxGroup ?? this.maxGroup,
      );

  factory Deck.fromMap(Map<String, dynamic> map) => Deck(
        map['id'],
        map['title'],
        map['sessions'],
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'sessions': maxGroup,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
