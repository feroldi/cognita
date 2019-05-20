import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'model/deck.dart';
import 'model/flashcard.dart';
import 'repository/deck_repository.dart';
import 'repository/flashcard_repository.dart';
import 'sqlite_repository/deck_sqlite_repository.dart';
import 'sqlite_repository/flashcard_sqlite_repository.dart';
import 'ui/home_page.dart';

class PrinterBlocDelegate extends BlocDelegate {
  @override
  void onError(Bloc bloc, Object error, StackTrace st) {
    super.onError(bloc, error, st);
    print('$error, $st');
  }
}

void main() async {
  BlocSupervisor().delegate = PrinterBlocDelegate();

  final databasesPath = await getDatabasesPath();
  String path = '${databasesPath}_cognita.db';

  final database = await openDatabase(path, version: 3,
      onCreate: (Database db, int version) async {
    await db.execute('CREATE TABLE IF NOT EXISTS decks ('
        'id INTEGER PRIMARY KEY,'
        'title TEXT,'
        'sessions INTEGER'
        ')');
    await db.execute('CREATE TABLE IF NOT EXISTS flashcards ('
        'id INTEGER PRIMARY KEY,'
        'box INTEGER,'
        'question TEXT,'
        'answer TEXT,'
        'deck_id INTEGER,'
        'FOREIGN KEY(deck_id) REFERENCES decks(id)'
        ')');
  });

  final deckRepository = DeckSqliteRepository(database);
  final flashcardRepository = FlashcardSqliteRepository(database);

  runApp(CognitaApp(
    deckRepository,
    flashcardRepository,
  ));
}

class CognitaApp extends StatelessWidget {
  final DeckRepository deckRepository;
  final FlashcardRepository flashcardRepository;

  CognitaApp(this.deckRepository, this.flashcardRepository);

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'Cognita',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(deckRepository, flashcardRepository),
    );

    return app;
  }
}
