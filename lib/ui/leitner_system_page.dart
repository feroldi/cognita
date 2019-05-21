import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../bloc/leitner_system_bloc.dart';
import '../model/deck.dart';
import '../model/flashcard.dart';
import '../repository/flashcard_repository.dart';

class LeitnerSystemPage extends StatefulWidget {
  final Deck deck;
  final FlashcardRepository flashcardRepository;

  LeitnerSystemPage(this.deck, this.flashcardRepository);

  @override
  _LeitnerSystemPageState createState() => _LeitnerSystemPageState();
}

class _LeitnerSystemPageState extends State<LeitnerSystemPage> {
  LeitnerSystemBloc bloc;

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

    final question = Markdown(
      data: flashcard.question,
    );
    final answer = state.isAnswerVisible
        ? Expanded(
            child: Markdown(
              data: flashcard.answer,
            ),
          )
        : FlatButton(
            onPressed: () => bloc.dispatch(RevealAnswerLSEvent()),
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: const Text('Reveal'),
          );
    final bottom = state.isAnswerVisible
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                onPressed: () => bloc
                    .dispatch(ClassifyFlashcardLSEvent(Classification.easy)),
                color: Colors.green[100],
                textColor: Colors.green,
                child: const Text('Easy'),
              ),
              FlatButton(
                onPressed: () => bloc
                    .dispatch(ClassifyFlashcardLSEvent(Classification.hard)),
                color: Colors.red[100],
                textColor: Colors.red,
                child: const Text('Hard'),
              ),
            ],
          )
        : SizedBox(height: 36.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(child: question),
        Divider(),
        answer,
        bottom,
        SizedBox(height: 5.0),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    bloc = LeitnerSystemBloc(widget.deck, widget.flashcardRepository)
      ..dispatch(StartLearningLSEvent());
  }
}
