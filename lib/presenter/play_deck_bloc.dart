import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/deck.dart';
import '../model/flashcard.dart';

class PlayDeckBloc extends Bloc<PlayDeckEvent, PlayDeckState> {
  @override
  PlayDeckState get initialState => PlayDeckUninit();

  @override
  Stream<PlayDeckState> mapEventToState(
      PlayDeckState currentState, PlayDeckEvent event) async* {
    if (event is PlayDeckInit) {
      assert(!event.deckToPlay.flashcards.isEmpty);
      final scoredFlashcards = event.deckToPlay.flashcards
          .map((flashcard) =>
              ScoredFlashcard(flashcard: flashcard, score: FlashcardScore.hard))
          .toList();
      final firstFlashcard = scoredFlashcards.removeAt(0);
      yield PlayingDeck(
        scoredFlashcards: scoredFlashcards,
        currentFlashcard: firstFlashcard,
        isRevealingAnswer: false,
      );
    }

    if (event is RevealFlashcardAnswerButtonPressed && currentState is PlayingDeck) {
      yield PlayingDeck(
          scoredFlashcards: currentState.scoredFlashcards,
          currentFlashcard: currentState.currentFlashcard,
          isRevealingAnswer: true,
      );
    }

    if (event is ScoreFlashcardButtonPressed && currentState is PlayingDeck) {
      const scoreToPositionMap = <FlashcardScore, int>{
        FlashcardScore.easy: 8,
        FlashcardScore.partial: 5,
        FlashcardScore.hard: 3
      };

      final int newFlashcardPosition = scoreToPositionMap[event.score];
      final newScoredFlashcard = ScoredFlashcard(
        flashcard: currentState.currentFlashcard.flashcard,
        score: event.score,
      );

      if (newFlashcardPosition > currentState.scoredFlashcards.length) {
        currentState.scoredFlashcards.add(newScoredFlashcard);
      } else {
        currentState.scoredFlashcards
            .insert(newFlashcardPosition - 1, newScoredFlashcard);
      }

      final nextFlashcard = currentState.scoredFlashcards.removeAt(0);

      yield PlayingDeck(
        scoredFlashcards: currentState.scoredFlashcards,
        currentFlashcard: nextFlashcard,
        isRevealingAnswer: false,
      );
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

abstract class PlayDeckState {}

class PlayDeckUninit implements PlayDeckState {}

class PlayingDeck implements PlayDeckState {
  final List<ScoredFlashcard> scoredFlashcards;
  final ScoredFlashcard currentFlashcard;
  bool isRevealingAnswer;

  PlayingDeck({
    @required this.scoredFlashcards,
    @required this.currentFlashcard,
    @required this.isRevealingAnswer,
  });
}

class ScoredFlashcard {
  final Flashcard flashcard;
  FlashcardScore score;

  ScoredFlashcard({@required this.flashcard, @required this.score});
}

enum FlashcardScore {
  easy,
  partial,
  hard,
}
