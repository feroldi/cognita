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
          icon: Icon(Icons.play_arrow),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  LeitnerSystemPage(widget.deck, widget.flashcardRepository),
            ));
            editDeckBloc.dispatch(EDEventLoadFlashcards());
          },
        ),
      ],
    );

    final scaffold = Scaffold(
      appBar: appBar,
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _onCreateFlashcard(context),
        child: Icon(Icons.add),
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

    return ListView.separated(
      separatorBuilder: (ctx, index) => Divider(height: 0.0),
      itemBuilder: (ctx, index) {
        if (index < flashcards.length) {
          final tile = ListTile(
            leading:
                Icon(Icons.short_text, color: Theme.of(context).accentColor),
            title: Text(flashcards[index].question),
            subtitle: Text(
                'Group ${flashcards[index].group} of ${editDeckBloc.deck.maxGroup}'),
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
