class Flashcard {
  int id;
  int deckId;
  int group;
  String question;
  String answer;

  Flashcard(
    this.id,
    this.deckId,
    this.group,
    this.question,
    this.answer,
  );

  Flashcard copyWith({
    int id,
    int deckId,
    int group,
    String question,
    String answer,
  }) =>
      Flashcard(
        id ?? this.id,
        deckId ?? this.deckId,
        group ?? this.group,
        question ?? this.question,
        answer ?? this.answer,
      );

  factory Flashcard.fromMap(Map<String, dynamic> map) => Flashcard(
        map['id'],
        map['deck_id'],
        map['box'],
        map['question'],
        map['answer'],
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'deck_id': deckId,
      'box': group,
      'question': question,
      'answer': answer,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
