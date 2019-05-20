import 'package:flutter/material.dart';

import 'model/deck.dart';
import 'model/flashcard.dart';
import 'repository/deck_repository.dart';
import 'repository/flashcard_repository.dart';
import 'ui/home_page.dart';

void main() {
  final decks = <Deck>[
    Deck(0, 'Test', 3),
  ];

  final flashcards = <Flashcard>[
    Flashcard(0, 0, 0, 'A', '3'),
    Flashcard(1, 0, 0, 'B', '1'),
    Flashcard(2, 0, 1, 'C', '9'),
    Flashcard(3, 0, 1, 'D', '4'),
    Flashcard(4, 0, 2, 'E', '7'),
    Flashcard(5, 0, 2, 'F', '8'),
  ];

  final deckRepository = MockDeckRepository(decks);
  final flashcardRepository = MockFlashcardRepository(flashcards);

  runApp(CognitaApp(deckRepository, flashcardRepository, decks));
}

class CognitaApp extends StatelessWidget {
  final DeckRepository deckRepository;
  final FlashcardRepository flashcardRepository;
  final List<Deck> decks;

  CognitaApp(this.deckRepository, this.flashcardRepository, this.decks);

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'Cognita',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(deckRepository, flashcardRepository),
    );

    return  app;
  }
}

class MockFlashcardRepository implements FlashcardRepository {
  final List<Flashcard> _data;

  MockFlashcardRepository([this._data = const <Flashcard>[]]);

  Future<Flashcard> load(int id) {
    return Future.value(_data.firstWhere((f) => f.id == id));
  }

  Future<List<Flashcard>> loadAllByDeckId(int deckId) {
    return Future.value(_data.where((f) => f.deckId == deckId).toList());
  }

  Future<void> store(Flashcard flashcard) {
    if (flashcard.id == null) {
      flashcard.id = _data.length;
    }

    final idx = _data.indexWhere((f) => f.id == flashcard.id);

    if (idx != -1) {
      _data[idx] = flashcard;
    } else {
      _data.add(flashcard);
    }
  }

  Future<Flashcard> remove(int id) {
    final idx = _data.indexWhere((f) => f.id == id);

    if (idx != -1) {
      return Future.value(_data.removeAt(idx));
    }

    return Future.value(null);
  }
}

class MockDeckRepository implements DeckRepository {
  final List<Deck> _data;

  MockDeckRepository([this._data = const <Deck>[]]);

  Future<Deck> load(int id) {
    return Future.value(_data.firstWhere((d) => d.id == id));
  }

  Future<List<Deck>> loadAll() {
    return Future.value(_data);
  }

  Future<void> store(Deck deck) {
    if (deck.id == null) {
      print('pois bem');
      deck.id = _data.length;
    }

    final idx = _data.indexWhere((d) => d.id == deck.id);

    if (idx != -1) {
      _data[idx] = deck;
    } else {
      _data.add(deck);
    }
  }
}
