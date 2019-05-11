import 'dart:async';

import '../model/flashcard.dart';
import '../repository/flashcard_repository.dart';

class TempFlashcardRepository implements FlashcardRepository {
  final _data = <int, Flashcard>{};

  Future<Flashcard> load(int id) {
    return Future.value(_data[id]);
  }

  Future<List<Flashcard>> loadAll() {
    return Future.value(_data.values.toList());
  }

  Future<void> store(Flashcard flashcard) {
    _data.update(flashcard.id, (_) => flashcard);
  }

  Future<void> storeAll(List<Flashcard> flashcards) {
    flashcards.forEach((flashcard) => store(flashcard));
  }
}
