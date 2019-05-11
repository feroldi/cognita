import 'package:flutter/material.dart';

import 'model/flashcard.dart';
import 'model/deck.dart';
import 'presenter/play_deck_bloc.dart';
import 'view/play_deck_page.dart';

void main() {
  final deck = Deck(
    id: 0,
    title: 'Teste',
    flashcards: <Flashcard>[
      Flashcard(
          id: 0,
          question: 'O que é Flutter?',
          answer: 'Um kit de desenvolvimento para aplicações mobile',
          score: FlashcardScore.hard),
      Flashcard(
          id: 1,
          question: 'O que é Dart?',
          answer: 'Uma linguagem de programação desenvolvida pela Google',
          score: FlashcardScore.hard),
      Flashcard(
          id: 2,
          question: 'O que é um cara bom?',
          answer: 'Um cara que dá o cu',
          score: FlashcardScore.hard),
      Flashcard(
          id: 3,
          question: 'O que é um cara filho da puta?',
          answer: 'Um cara honesto que só se fode',
          score: FlashcardScore.hard),
      Flashcard(
          id: 4,
          question: 'Defina o namoro antes dos 30 anos',
          answer: 'Os 30s precoce',
          score: FlashcardScore.hard),
      Flashcard(
          id: 5,
          question: 'Quanto é 1 + 1?',
          answer: '2',
          score: FlashcardScore.hard),
      Flashcard(
          id: 6,
          question: 'Quem é "cadê meu chocolate"?',
          answer: 'É uma garota que passou por nós dois falando essa frase',
          score: FlashcardScore.hard),
      Flashcard(
          id: 7,
          question: 'My life shines o quê?',
          answer: 'My life shines on!',
          score: FlashcardScore.hard),
    ],
  );

  final playDeckBloc = PlayDeckBloc()..dispatch(PlayDeckInit(deckToPlay: deck));

  runApp(RootApp(playDeckBloc));
}

class RootApp extends StatelessWidget {
  final PlayDeckBloc playDeckBloc;

  RootApp(this.playDeckBloc);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
      ),
      home: HomeScreen(playDeckBloc),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final PlayDeckBloc playDeckBloc;

  HomeScreen(this.playDeckBloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cognita'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return PlayDeckPage(playDeckBloc: playDeckBloc);
  }
}
