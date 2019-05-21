import 'dart:io';
import 'dart:convert';

import 'package:bloc/bloc.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory, getExternalStorageDirectory;
import 'package:simple_permissions/simple_permissions.dart';

import '../model/deck.dart';
import '../model/flashcard.dart';
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
      final flashcards =
          await flashcardRepository.loadAllByDeckId(event.deck.id);
      for (final flashcard in flashcards) {
        await flashcardRepository.remove(flashcard.id);
      }
      await deckRepository.remove(event.deck.id);
      final decks = await deckRepository.loadAll();
      yield DecksHomeState(decks);
    }

    if (event is HomeEventExportData) {
      await SimplePermissions.requestPermission(
          Permission.WriteExternalStorage);
      final bool permitted = await SimplePermissions.checkPermission(
          Permission.WriteExternalStorage);

      if (permitted) {
        yield LoadingHomeState();

        final decks = await deckRepository.loadAll();
        final flashcards = await deckRepository.loadAll();
        final collection = <String, dynamic>{
          'decks': decks.map((deck) => deck.toMap()).toList(),
          'flashcards':
              flashcards.map((flashcard) => flashcard.toMap()).toList(),
        };
        final data = json.encode(collection);

        final dateFmt = intl.DateFormat('yyyy-MM-dd');
        final now = dateFmt.format(DateTime.now());
        final externalDir = (await getExternalStorageDirectory()).absolute.path;
        final downloadDir = Directory('$externalDir/Download');
        final file = File('${downloadDir.path}/cognita_data_$now.json');
        await file.writeAsString(data);

        yield DecksHomeState(decks);
      }
    }

    if (event is HomeEventImportData) {
      await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
      final bool permitted = await SimplePermissions.checkPermission(
          Permission.ReadExternalStorage);

      if (permitted) {
        yield LoadingHomeState();
        /*
        final file = await FilePicker.getFile(
            type: FileType.CUSTOM, fileExtension: 'JSON');
        final data = await file.readAsString();
        final collection = json.decode(data);
        final decks =
            collection['decks'].map((map) => Deck.fromMap(map)).toList();
        final flashcards = collection['flashcards']
            .map((map) => Flashcard.fromMap(map))
            .toList();

        for (final deck in decks) {
          final oldDeckId = deck.id;
          deck.id = null;
          final newDeck = await deckRepository.store(deck);
          for (final flashcard
              in flashcards.where((fc) => fc.deckId == oldDeckId)) {
            flashcard.id = null;
            flashcard.deckId = newDeck.id;
            await flashcardRepository.store(flashcard);
          }
        }

        */
        yield DecksHomeState(await deckRepository.loadAll());
      }
    }
  }
}

abstract class HomeEvent {}

class LoadDecksHomeEvent implements HomeEvent {}

class HomeEventDeleteDeck implements HomeEvent {
  final Deck deck;
  HomeEventDeleteDeck(this.deck);
}

class HomeEventExportData implements HomeEvent {}

class HomeEventImportData implements HomeEvent {}

abstract class HomeState {}

class LoadingHomeState implements HomeState {}

class DecksHomeState implements HomeState {
  final List<Deck> decks;
  DecksHomeState(this.decks);
}
