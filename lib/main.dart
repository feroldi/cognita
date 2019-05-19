import 'package:flutter/material.dart';

import 'bloc/leitner_system_bloc.dart';
import 'model/deck.dart';
import 'model/flashcard.dart';
import 'repository/flashcard_repository.dart';
import 'ui/leitner_system_page.dart';

void main() {
  final flashcards = <Flashcard>[
    Flashcard(0, 0, 'A', '3'),
    Flashcard(1, 0, 'B', '1'),
    Flashcard(2, 1, 'C', '9'),
    Flashcard(3, 1, 'D', '4'),
    Flashcard(4, 2, 'E', '7'),
    Flashcard(5, 2, 'F', '8'),
  ];
  final flashcardRepository = MockFlashcardRepository(flashcards);
  final deck = Deck(0, 'Test', List<int>.generate(6, (i) => i), 3);
  final bloc = LeitnerSystemBloc(deck, flashcardRepository);
  bloc.dispatch(StartLearningLSEvent());

  runApp(RootApp(bloc));
}

class RootApp extends StatelessWidget {
  final LeitnerSystemBloc bloc;

  RootApp(this.bloc);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cognita2',
      home: LeitnerSystemPage(bloc),
    );
  }
}

class MockFlashcardRepository implements FlashcardRepository {
  List<Flashcard> _data;

  MockFlashcardRepository(this._data);

  Future<Flashcard> load(int id) {
    return Future.value(_data.firstWhere((f) => f.id == id));
  }

  Future<void> store(Flashcard flashcard) {
    final idx = _data.indexWhere((f) => f.id == flashcard.id);
    if (idx != -1) {
      _data[idx] = flashcard;
    } else {
      _data.add(flashcard);
    }
  }
}
