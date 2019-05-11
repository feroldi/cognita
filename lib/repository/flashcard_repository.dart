import 'dart:async';

import '../model/flashcard.dart';

abstract class FlashcardRepository {
  Future<Flashcard> load(int id);
  Future<List<Flashcard>> loadAll();
  Future<void> store(Flashcard flashcard);
  Future<void> storeAll(List<Flashcard> flashcards);
}
