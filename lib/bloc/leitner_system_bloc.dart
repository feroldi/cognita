import 'package:bloc/bloc.dart';

import '../model/deck.dart';
import '../model/flashcard.dart';
import '../repository/flashcard_repository.dart';

class LeitnerSystemBloc extends Bloc<LSEvent, LSState> {
  final Deck deck;
  final FlashcardRepository flashcardRepository;
  int currentFlashcardIdx = 0;
  int currentSession = 0;
  List<Flashcard> learningSet = <Flashcard>[];

  LeitnerSystemBloc(this.deck, this.flashcardRepository);

  @override
  LSState get initialState => LSState(null);

  @override
  Stream<LSState> mapEventToState(LSEvent event) async* {
    if (event is StartLearningLSEvent) {
      // We can't start the system with a dirty learning set.
      assert(learningSet.isEmpty);

      // Load all the deck's flashcards, then sort it by group.
      learningSet = await flashcardRepository.loadAllByDeckId(deck.id);
      learningSet.sort((a, b) => a.group.compareTo(b.group));

      // Use the first flashcard as the initial one.
      yield LSState(learningSet.first);
    }

    if (event is RevealAnswerLSEvent) {
      // Make the answer part of the flashcard visible to the user.
      yield LSState(currentState.currentFlashcard, isAnswerVisible: true);
    }

    if (event is ClassifyFlashcardLSEvent) {
      // Change the current flashcard's group classification. If it was a
      // positive classification, then promote the flashcard, otherwise set it
      // back to the initial group.
      if (event.classification == Classification.easy) {
        // Promote this flashcard, but only if it's not in the last group.
        if (currentState.currentFlashcard.group < deck.maxGroup) {
          currentState.currentFlashcard.group++;
        }
      } else {
        assert(event.classification == Classification.hard);
        // Reset the flashcard to the initial group, so it can be iterated
        // again in the next session.
        currentState.currentFlashcard.group = 0;
      }

      // Save the flashcard modifications.
      await flashcardRepository.store(currentState.currentFlashcard);

      // Go forward to the next flashcard, or, if it's gone through all
      // flashcard, advance one session.
      if (currentFlashcardIdx < (learningSet.length - 1) &&
          learningSet[currentFlashcardIdx + 1].group <= currentSession) {
        // Still in the same session, so advance one flashcard.
        currentFlashcardIdx++;
      } else {
        // This session has ended, so advance one session and start from the
        // first flashcard. If it's the last session, then reset it to the
        // first one.
        currentFlashcardIdx = 0;
        currentSession = (currentSession + 1) % deck.maxGroup;
        learningSet.sort((a, b) => a.group.compareTo(b.group));

        // Sometimes, a group is left with no flashcard in it. So, this means
        // that some sessions may be skipped to the very next one that contains
        // any flashcards (i.e., the first flashcard's group indicates to which
        // session it should skip).
        if (learningSet.first.group > currentSession) {
          currentSession = learningSet.first.group;
        }
      }

      yield LSState(learningSet[currentFlashcardIdx]);
    }
  }
}

abstract class LSEvent {}

class StartLearningLSEvent implements LSEvent {}

enum Classification {
  easy,
  hard,
}

class RevealAnswerLSEvent implements LSEvent {}

class ClassifyFlashcardLSEvent implements LSEvent {
  final Classification classification;
  ClassifyFlashcardLSEvent(this.classification);
}

class LSState {
  final Flashcard currentFlashcard;
  final bool isAnswerVisible;
  LSState(this.currentFlashcard, {this.isAnswerVisible = false});
}
