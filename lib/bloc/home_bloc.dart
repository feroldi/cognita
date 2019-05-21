import 'package:bloc/bloc.dart';

import '../model/deck.dart';
import '../repository/deck_repository.dart';
import '../repository/flashcard_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DeckRepository deckRepository;
  final FlashcardRepository flashcardRepository;

  @override
  HomeState get initialState => LoadingHomeState();

  HomeBloc(this.deckRepository, this.flashcardRepository);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadDecksHomeEvent) {
      yield LoadingHomeState();
      final decks = await deckRepository.loadAll();
      yield DecksHomeState(decks);
    }

    if (event is HomeEventDeleteDeck) {
      final flashcards = await flashcardRepository.loadAllByDeckId(event.deck.id);
      for (final flashcard in flashcards) {
        await flashcardRepository.remove(flashcard.id);
      }
      await deckRepository.remove(event.deck.id);
      final decks = await deckRepository.loadAll();
      yield DecksHomeState(decks);
    }
  }
}

abstract class HomeEvent {}

class LoadDecksHomeEvent implements HomeEvent {}

class HomeEventDeleteDeck implements HomeEvent {
  final Deck deck;
  HomeEventDeleteDeck(this.deck);
}

abstract class HomeState {}

class LoadingHomeState implements HomeState {}

class DecksHomeState implements HomeState {
  final List<Deck> decks;
  DecksHomeState(this.decks);
}
