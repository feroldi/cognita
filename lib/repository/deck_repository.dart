import 'dart:async';

import '../model/deck.dart';

abstract class DeckRepository {
  Future<Deck> load(int id);
  Future<List<Deck>> loadAll();
  Future<Deck> store(Deck deck);
  Future<Deck> remove(int id);
}
