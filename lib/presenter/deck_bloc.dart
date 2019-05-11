import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/deck.dart';

class PlayDeckBloc extends Bloc<PlayDeckEvent, PlayDeckState> {
  @override
  PlayDeckState get initialState => PlayDeckUninit();

  @override
  Stream<PlayDeckState> mapEventToState(PlayDeckEvent event) async* {
    if (event is PlayDeckInit) {
      assert(!event.deck.flashcards.isEmpty);
      final scoredFlashcards = event.deck.flashcards
          .map((flashcard) => ScoredFlashcard(flashcard: flashcard, score: FlashcardScore.hard));
      final firstFlashcard = scoredFlashcards.removeAt(0);
      yield PlayingDeck(scoredFlashcards: scoredFlashcards, currentFlashcard: firstFlashcard);
    }

    if (event is ScoreFlashcardButtonPressed && currentState is PlayingDeck) {
      // TODO insert flashcard at another position according to the new score, and
      // remove the first flashcard to be the next to play.
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
        currentState.scoredFlashcards.insert(newFlashcardPosition - 1, newScoredFlashcard);
      }

      final nextFlashcard = currentState.scoredFlashcards.removeAt(0);

      yield PlayingDeck(
          scoredFlashcards: currentState.scoredFlashcards, currentFlashcard: nextFlashcard);
    }
  }
}

abstract class PlayDeckEvent {}

class PlayDeckInit implements PlayDeckEvent {
  final Deck deckToPlay;

  PlayDeckInit({@required this.deckToPlay});
}

enum FlashcardScore {
  easy,
  partial,
  hard,
}

class ScoreFlashcardButtonPressed implements PlayDeckEvent {
  final FlashcardScore score;
  ScoreFlashcardButtonPressed(this.score);
}

abstract class PlayDeckState {}

class PlayDeckUninit implements PlayDeckState {}

class ScoredFlashcard {
  final Flashcard flashcard;
  FlashcardScore score;

  ScoredFlashcard({@required this.flashcard, @required this.score});
}

class PlayingDeck implements PlayDeckState {
  final List<ScoredFlashcard> scoredFlashcards;
  final ScoredFlashcard currentFlashcard;

  PlayingDeck({@required this.scoredFlashcards, @required this.currentFlashcard});
}
