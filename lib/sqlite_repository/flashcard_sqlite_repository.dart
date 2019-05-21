import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../model/flashcard.dart';
import '../repository/flashcard_repository.dart';

class FlashcardSqliteRepository implements FlashcardRepository {
  final Database database;

  FlashcardSqliteRepository(this.database);

  Future<Flashcard> load(int id) async {
    final result = await database.query(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Flashcard.fromMap(result.first);
    }
    return null;
  }

  Future<List<Flashcard>> loadAllByDeckId(int deckId) async {
    final results = await database.query(
      'flashcards',
      where: 'deck_id = ?',
      whereArgs: [deckId],
    );
    return results.map<Flashcard>((value) => Flashcard.fromMap(value)).toList();
  }

  Future<Flashcard> store(Flashcard flashcard) async {
    if (flashcard.id != null) {
      await database.transaction((tx) async {
        final result = await tx.query(
          'flashcards',
          where: 'id = ?',
          whereArgs: [flashcard.id],
        );
        if (result.isNotEmpty) {
          await tx.update(
            'flashcards',
            flashcard.toMap(),
            where: 'id = ?',
            whereArgs: [flashcard.id],
          );
        } else {
          await tx.insert('flashcards', flashcard.toMap());
        }
        return flashcard.copyWith();
      });
    } else {
      final flashcardId = await database.insert('flashcards', flashcard.toMap());
      return flashcard.copyWith(id: flashcardId);
    }
  }

  Future<Flashcard> remove(int id) async {
    await database.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
