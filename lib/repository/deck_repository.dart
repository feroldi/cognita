import 'dart:async';

import '../model/deck.dart';

abstract class DeckRepository {
  Future<Deck> load(int id);
  Future<List<Deck>> loadAll();
  Future<void> store(Deck deck);
  Future<void> storeAll(List<Deck> decks);
}
