import 'package:bloc/bloc.dart';

import '../model/deck.dart';
import '../repository/deck_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DeckRepository deckRepository;

  @override
  HomeState get initialState => LoadingHomeState();

  HomeBloc(this.deckRepository);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is LoadDecksHomeEvent) {
      yield LoadingHomeState();
      final decks = await deckRepository.loadAll();
      yield DecksHomeState(decks);
    }
  }
}

abstract class HomeEvent {}

class LoadDecksHomeEvent implements HomeEvent {}

abstract class HomeState {}

class LoadingHomeState implements HomeState {}

class DecksHomeState implements HomeState {
  final List<Deck> decks;
  DecksHomeState(this.decks);
}
