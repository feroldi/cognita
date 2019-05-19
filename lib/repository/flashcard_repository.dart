import 'dart:async';

import '../model/flashcard.dart';

abstract class FlashcardRepository {
  Future<Flashcard> load(int id);
  Future<void> store(Flashcard flashcard);
}
