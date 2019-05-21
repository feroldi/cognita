import 'dart:async';

import '../model/flashcard.dart';

abstract class FlashcardRepository {
  Future<Flashcard> load(int id);
  Future<List<Flashcard>> loadAllByDeckId(int deckId);
  Future<Flashcard> store(Flashcard flashcard);
  Future<Flashcard> remove(int id);
}
