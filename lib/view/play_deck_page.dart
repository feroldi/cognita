import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../model/flashcard.dart';
import '../model/deck.dart';
import '../presenter/play_deck_bloc.dart';
import 'widgets/dash_divider.dart';

class PlayDeckPage extends StatelessWidget {
  final PlayDeckBloc playDeckBloc;

  PlayDeckPage({@required this.playDeckBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayDeckEvent, PlayDeckState>(
      bloc: playDeckBloc,
      builder: (ctx, state) {
        if (state is PlayDeckUninit) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is StoppedDeck) {
          return Center(child: const Text('Parabéns!'));
        }

        if (state is PlayingDeck) {
          final flashcard = state.curFlashcard;

          return Column(
            children: <Widget>[
              Expanded(
                child: state.isRevealingAnswer
                    ? _buildFlashcardQuestionAnswer(flashcard)
                    : _buildFlashcardQuestion(context, flashcard),
              ),
              state.isRevealingAnswer
                  ? _buildScoreButtons()
                  : SizedBox(height: 40.0),
            ],
          );
        }
      },
    );
  }

  Widget _buildFlashcardQuestion(BuildContext context, Flashcard flashcard) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(flashcard.question, style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
          DashDivider(),
          _buildRevealAnswerButton(context),
        ]);
  }

  Widget _buildFlashcardQuestionAnswer(Flashcard flashcard) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(flashcard.question, style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
          DashDivider(),
          Text(flashcard.answer, style: TextStyle(fontSize: 24.0), textAlign: TextAlign.center,),
        ]);
  }

  Widget _buildRevealAnswerButton(BuildContext context) {
    return Center(
      child: FlatButton(
        onPressed: () =>
            playDeckBloc.dispatch(RevealFlashcardAnswerButtonPressed()),
        color: Theme.of(context).accentColor,
        textColor: Colors.white,
        child: const Text('Resposta'),
      ),
    );
  }

  Widget _buildScoreButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(
          onPressed: () => playDeckBloc
              .dispatch(ScoreFlashcardButtonPressed(FlashcardScore.easy)),
          color: Colors.green,
          textColor: Colors.white,
          child: const Text('Acertei'),
        ),
        FlatButton(
          onPressed: () => playDeckBloc
              .dispatch(ScoreFlashcardButtonPressed(FlashcardScore.partial)),
          color: Colors.amber,
          textColor: Colors.white,
          child: const Text('Quase'),
        ),
        FlatButton(
          onPressed: () => playDeckBloc
              .dispatch(ScoreFlashcardButtonPressed(FlashcardScore.hard)),
          color: Colors.red,
          textColor: Colors.white,
          child: const Text('Errei'),
        ),
      ],
    );
  }
}
