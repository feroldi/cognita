import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/leitner_system_bloc.dart';
import '../model/deck.dart';
import '../model/flashcard.dart';
import '../repository/flashcard_repository.dart';

class LeitnerSystemPage extends StatelessWidget {
  final LeitnerSystemBloc bloc;

  LeitnerSystemPage(this.bloc);

  @override
  Widget build(BuildContext context) {
    final flashcard = BlocBuilder<LSEvent, LSState>(
      bloc: bloc,
      builder: _buildFlashcard,
    );

    final appBar = AppBar(
      title: Text(bloc.deck.title),
    );

    final scaffold = Scaffold(
      appBar: appBar,
      body: flashcard,
    );

    return scaffold;
  }

  Widget _buildFlashcard(BuildContext context, LSState state) {
    if (state.currentFlashcard == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final flashcard = state.currentFlashcard;
    final question = Text(
      flashcard.question,
      style: TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
    final answer = state.isAnswerVisible
        ? Text(
            flashcard.answer,
            style: TextStyle(fontSize: 24.0),
            textAlign: TextAlign.center,
          )
        : FlatButton(
            onPressed: () => bloc.dispatch(RevealAnswerLSEvent()),
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: const Text('Resposta'),
          );
    final bottom = state.isAnswerVisible
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: () => bloc
                    .dispatch(ClassifyFlashcardLSEvent(Classification.easy)),
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('Fácil'),
              ),
              FlatButton(
                onPressed: () => bloc
                    .dispatch(ClassifyFlashcardLSEvent(Classification.hard)),
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Difícil'),
              ),
            ],
          )
        : SizedBox(height: 24.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        question,
        Divider(),
        answer,
        bottom,
      ],
    );
  }
}
