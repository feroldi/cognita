import 'package:meta/meta.dart';

import 'flashcard.dart';

class Deck {
  final int id;
  final List<Flashcard> flashcards;
  Deck({@required this.id, @required this.flashcards});
}
