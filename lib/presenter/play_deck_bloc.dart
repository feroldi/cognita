import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/deck.dart';
import '../model/flashcard.dart';

class PlayDeckBloc extends Bloc<PlayDeckEvent, PlayDeckState> {
  @override
  PlayDeckState get initialState => PlayDeckUninit();

  @override
  void onError(Object error, StackTrace st) {
    print(error);
  }

  @override
  Stream<PlayDeckState> mapEventToState(
      PlayDeckState curState, PlayDeckEvent event) async* {
    if (event is PlayDeckInit) {
      assert(!event.deckToPlay.flashcards.isEmpty);
      final deck = event.deckToPlay;
      final firstFlashcard = deck.flashcards.removeAt(0);
      yield PlayingDeck(
        deck: deck,
        curFlashcard: firstFlashcard,
        isRevealingAnswer: false,
      );
    }

    if (event is RevealFlashcardAnswerButtonPressed &&
        curState is PlayingDeck) {
      yield curState.copyWith(
        isRevealingAnswer: true,
      );
    }

    if (event is ScoreFlashcardButtonPressed && curState is PlayingDeck) {
      final scoreToPositionMap = <FlashcardScore, int>{
        FlashcardScore.easy: curState.deck.flashcards.length + 1,
        FlashcardScore.partial: 5,
        FlashcardScore.hard: 3
      };

      final int newFlashcardPosition = scoreToPositionMap[event.score];
      final flashcardWithNewScore = curState.curFlashcard.copyWith(score: event.score);

      if (newFlashcardPosition > curState.deck.flashcards.length) {
        curState.deck.flashcards.add(flashcardWithNewScore);
      } else {
        curState.deck.flashcards
            .insert(newFlashcardPosition - 1, flashcardWithNewScore);
      }

      final nextFlashcard = curState.deck.flashcards.removeAt(0);

      yield curState.copyWith(
        curFlashcard: nextFlashcard,
        isRevealingAnswer: false,
      );
    }

    if (event is StopButtonPressed && curState is PlayingDeck) {
      curState.deck.flashcards.add(curState.curFlashcard);
      yield StoppedDeck(deck: curState.deck);
    }
  }
}

abstract class PlayDeckEvent {}

class PlayDeckInit implements PlayDeckEvent {
  final Deck deckToPlay;

  PlayDeckInit({@required this.deckToPlay});
}

class ScoreFlashcardButtonPressed implements PlayDeckEvent {
  final FlashcardScore score;
  ScoreFlashcardButtonPressed(this.score);
}

class RevealFlashcardAnswerButtonPressed implements PlayDeckEvent {}

class StopButtonPressed implements PlayDeckEvent {}

abstract class PlayDeckState {}

class PlayDeckUninit implements PlayDeckState {}

class PlayingDeck implements PlayDeckState {
  final Deck deck;
  final Flashcard curFlashcard;
  bool isRevealingAnswer;

  PlayingDeck({
    @required this.deck,
    @required this.curFlashcard,
    @required this.isRevealingAnswer,
  });

  PlayingDeck copyWith({
    Deck deck,
    Flashcard curFlashcard,
    bool isRevealingAnswer,
  }) =>
      PlayingDeck(
        deck: deck ?? this.deck,
        curFlashcard: curFlashcard ?? this.curFlashcard,
        isRevealingAnswer: isRevealingAnswer ?? this.isRevealingAnswer,
      );
}

class StoppedDeck implements PlayDeckState {
  final Deck deck;
  StoppedDeck({@required this.deck});
}
