import 'package:bloc/bloc.dart';

import '../model/deck.dart';
import '../model/flashcard.dart';
import '../repository/flashcard_repository.dart';

class EditDeckBloc extends Bloc<EDEvent, EDState> {
  final Deck deck;
  final FlashcardRepository flashcardRepository;

  EditDeckBloc(this.deck, this.flashcardRepository);

  @override
  EDState get initialState => EDStateLoading();

  @override
  Stream<EDState> mapEventToState(EDEvent event) async* {
    if (event is EDEventLoadFlashcards) {
      final flashcards = await flashcardRepository.loadAllByDeckId(deck.id);
      yield EDStateFlashcards(flashcards);
    }

    if (event is EDEventCreateFlashcard) {
      await flashcardRepository.store(Flashcard(
        null,
        deck.id,
        0,
        event.question,
        event.answer,
      ));
      dispatch(EDEventLoadFlashcards());
    }

    if (event is EDEventEditFlashcard) {
      assert(event.flashcard.deckId == deck.id);
      await flashcardRepository.store(event.flashcard);
      dispatch(EDEventLoadFlashcards());
    }
  }
}

abstract class EDEvent {}

class EDEventLoadFlashcards implements EDEvent {}

class EDEventCreateFlashcard implements EDEvent {
  String question;
  String answer;
  EDEventCreateFlashcard(this.question, this.answer);
}

class EDEventEditFlashcard implements EDEvent {
  final Flashcard flashcard;
  EDEventEditFlashcard(this.flashcard);
}

abstract class EDState {}

class EDStateLoading implements EDState {}

class EDStateFlashcards implements EDState {
  final List<Flashcard> flashcards;
  EDStateFlashcards(this.flashcards);
}
