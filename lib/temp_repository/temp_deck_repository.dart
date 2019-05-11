import 'dart:async';

import 'package:meta/meta.dart';

import '../model/deck.dart';
import '../repository/deck_repository.dart';

class TempDeckRepository implements DeckRepository {
  final _data = <int, Deck>{};

  Future<Deck> load(int id) {
    return Future.value(_data[id]);
  }

  Future<List<Deck>> loadAll() {
    return Future.value(_data.values.toList());
  }

  Future<void> store(Deck deck) {
    _data.update(deck.id, (_) => deck);
  }

  Future<void> storeAll(List<Deck> decks) {
    decks.forEach((deck) => store(deck));
  }
}
