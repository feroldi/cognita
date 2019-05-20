import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/edit_deck_bloc.dart';
import '../model/deck.dart';
import '../model/flashcard.dart';
import '../repository/flashcard_repository.dart';
import '../ui/edit_flashcard_page.dart';
import '../ui/leitner_system_page.dart';

class EditDeckPage extends StatefulWidget {
  final Deck deck;
  final FlashcardRepository flashcardRepository;

  EditDeckPage(this.deck, this.flashcardRepository);

  @override
  _EditDeckPageState createState() => _EditDeckPageState();
}

class _EditDeckPageState extends State<EditDeckPage> {
  EditDeckBloc editDeckBloc;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(editDeckBloc.deck.title),
      actions: <Widget>[
        IconButton(
          //icon: Icon(Icons.play_arrow),
          icon: Icon(Icons.video_library),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  LeitnerSystemPage(widget.deck, widget.flashcardRepository),
            ));
            editDeckBloc.dispatch(EDEventLoadFlashcards());
          },
        ),
        IconButton(
          icon: Icon(Icons.replay),
          onPressed: () async {
            final bool shouldResetDeck = await _dialogShouldResetDeck(context);
            if (shouldResetDeck) {
              editDeckBloc.dispatch(EDEventResetFlashcardsGroup());
            }
          },
        ),
      ],
    );

    final scaffold = Scaffold(
      appBar: appBar,
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _onCreateFlashcard(context),
        child: Icon(Icons.note_add),
      ),
    );

    return scaffold;
  }

  Widget _buildBody() {
    return BlocBuilder<EDEvent, EDState>(
      bloc: editDeckBloc,
      builder: (context, state) {
        if (state is EDStateLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is EDStateFlashcards) {
          return _buildFlashcardList(context, state.flashcards);
        }
      },
    );
  }

  Widget _buildFlashcardList(BuildContext context, List<Flashcard> flashcards) {
    if (flashcards.isEmpty) {
      return Center(
        child: Text(
          'Empty',
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 24.0),
        ),
      );
    }

    final proficiencyColors = <Color>[
      Colors.red,
      Colors.blue,
      Colors.green,
    ];

    return ListView.separated(
      separatorBuilder: (ctx, index) => Divider(height: 0.0),
      itemBuilder: (ctx, index) {
        if (index < flashcards.length) {
          final proficiencyColorIndex =
              (((flashcards[index].group) / editDeckBloc.deck.maxGroup) * 3)
                  .toInt();
          final tile = ListTile(
            leading: Icon(Icons.note, color: Theme.of(context).accentColor),
            trailing: Icon(Icons.offline_bolt,
                color: proficiencyColors[proficiencyColorIndex]),
            title: Text(
              flashcards[index].question,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
                'Box ${flashcards[index].group + 1}/${editDeckBloc.deck.maxGroup}'),
            onTap: () => _onEditFlashcard(context, flashcards[index]),
          );
          return Dismissible(
            key: Key('flashcard ${flashcards[index].id}'),
            child: tile,
            background: Container(
                alignment: AlignmentDirectional.centerStart,
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.delete_forever, color: Colors.white),
                )),
            secondaryBackground: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.delete_forever, color: Colors.white),
                )),
            onDismissed: (direction) =>
                _onFlashcardDismissed(flashcards[index], direction),
            confirmDismiss: (direction) =>
                _confirmFlashcardDismiss(context, direction),
          );
        } else {
          return SizedBox(height: 80.0);
        }
      },
      itemCount: flashcards.length + 1,
    );
  }

  void _onCreateFlashcard(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditFlashcardPage(
            '',
            '',
            isEditing: false,
            onSaveAction: (question, answer) {
              editDeckBloc.dispatch(EDEventCreateFlashcard(question, answer));
            },
          ),
    ));
  }

  void _onEditFlashcard(BuildContext context, Flashcard flashcard) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditFlashcardPage(
            flashcard.question,
            flashcard.answer,
            onSaveAction: (question, answer) {
              editDeckBloc.dispatch(EDEventEditFlashcard(flashcard.copyWith(
                question: question,
                answer: answer,
              )));
            },
          ),
    ));
  }

  void _onFlashcardDismissed(
      Flashcard flashcard, DismissDirection direction) async {
    await widget.flashcardRepository.remove(flashcard.id);
    editDeckBloc.dispatch(EDEventLoadFlashcards());
  }

  Future<bool> _confirmFlashcardDismiss(
      BuildContext context, DismissDirection direction) async {
    final dialogMessage =
        'Are you sure you want to remove this flashcard from the deck?';
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Delete flashcard'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(dialogMessage),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
            FlatButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _dialogShouldResetDeck(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Reset deck'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to reset this deck to its initial stage?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
            FlatButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    editDeckBloc = EditDeckBloc(widget.deck, widget.flashcardRepository)
      ..dispatch(EDEventLoadFlashcards());
  }

  @override
  void dispose() {
    editDeckBloc.dispose();
    super.dispose();
  }
}
