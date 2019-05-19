import 'dart:async';

import 'package:cognita2/bloc/leitner_system_bloc.dart';
import 'package:cognita2/model/deck.dart';
import 'package:cognita2/model/flashcard.dart';
import 'package:cognita2/repository/flashcard_repository.dart';
import 'package:test/test.dart';

void main() {
  test('A, B and C should go to the middle group', () {
    final flashcards = <Flashcard>[
      Flashcard(0, 0, 'A', '1'),
      Flashcard(1, 0, 'B', '2'),
      Flashcard(2, 0, 'C', '3'),
      Flashcard(3, 1, 'D', '4'),
      Flashcard(4, 1, 'E', '5'),
      Flashcard(5, 1, 'F', '6'),
      Flashcard(6, 2, 'G', '7'),
      Flashcard(7, 2, 'H', '8'),
      Flashcard(8, 2, 'I', '9'),
    ];
    final flashcardRepository = MockFlashcardRepository(flashcards);
    final deck = Deck(0, 'Test', List<int>.generate(9, (i) => i), 3);
    final bloc = LeitnerSystemBloc(deck, flashcardRepository);

    expect(bloc.currentState.currentFlashcard, null);

    bloc.dispatch(StartLearningLSEvent());
    bloc.dispatch(ClassifyFlashcardLSEvent(Classification.easy));
    bloc.dispatch(ClassifyFlashcardLSEvent(Classification.easy));
    bloc.dispatch(ClassifyFlashcardLSEvent(Classification.easy));

    expect(bloc.state, emitsInOrder([
      LSState(null),
      LSState(flashcards[0]),
      LSState(flashcards[1]),
      LSState(flashcards[2]),
    ]));
  });
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
