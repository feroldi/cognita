import 'package:meta/meta.dart';

enum FlashcardScore {
  easy,
  partial,
  hard,
}

class Flashcard {
  final int id;
  final String question;
  final String answer;
  FlashcardScore score;

  Flashcard({
    @required this.id,
    @required this.question,
    @required this.answer,
    @required this.score,
  });

  Flashcard copyWith({
    int id,
    String question,
    String answer,
    FlashcardScore score,
  }) =>
      Flashcard(
        id: id ?? this.id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        score: score ?? this.score,
      );
}
