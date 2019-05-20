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
}
