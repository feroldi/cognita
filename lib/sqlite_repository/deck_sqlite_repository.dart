import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../model/deck.dart';
import '../repository/deck_repository.dart';

class DeckSqliteRepository implements DeckRepository {
  final Database database;

  DeckSqliteRepository(this.database);

  Future<Deck> load(int id) async {
    final result = await database.query(
      'decks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Deck.fromMap(result.first);
    }
    return null;
  }

  Future<List<Deck>> loadAll() async {
    final results = await database.query('decks');
    return results.map<Deck>((value) => Deck.fromMap(value)).toList();
  }

  Future<void> store(Deck deck) async {
    if (deck.id != null) {
      await database.transaction((tx) async {
        final result = await tx.query(
          'decks',
          where: 'id = ?',
          whereArgs: [deck.id],
        );
        if (result.isNotEmpty) {
          await tx.update(
            'decks',
            deck.toMap(),
            where: 'id = ?',
            whereArgs: [deck.id],
          );
        } else {
          await tx.insert('decks', deck.toMap());
        }
      });
    } else {
      await database.insert('decks', deck.toMap());
    }
  }

  Future<Deck> remove(int id) async {
    await database.delete(
      'decks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
