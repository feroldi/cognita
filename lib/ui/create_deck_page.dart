import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../model/deck.dart';
import '../repository/deck_repository.dart';

const String sessionExplanationMessage =
    "A deck contains a number of boxes which holds flashcards. When you learn a "
    "deck, you start by taking the flashcards from the first box.  When you are done "
    "classifying them as easy or hard, you put some of the flashcards back to the "
    "first box if you failed them, or to the next box if you succeeded them. "
    "On the next learning session, you take the flashcards from the first and second boxes "
    "and repeat the same process."
    "\n\n"
    "A session is an iteration of the deck's flashcards. The first session takes "
    "the flashcards from the first box. The second session takes the flashcards from "
    "the first and second box, and so on. "
    "\n\n"
    "There are as many sessions as boxes. The idea is to get in a place where all "
    "of the deck's flashcards are held by the last box, which means you learned the "
    "entire deck! ";

class CreateDeckPage extends StatefulWidget {
  final DeckRepository deckRepository;

  CreateDeckPage(this.deckRepository);

  @override
  _CreateDeckPageState createState() => _CreateDeckPageState();
}

class _CreateDeckPageState extends State<CreateDeckPage> {
  final titleTextCtrl = TextEditingController();
  final groupTextCtrl = TextEditingController();
  final _formValidator = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final titleTextField = TextFormField(
      controller: titleTextCtrl,
      validator: (text) {
        if (text.trim().isEmpty) {
          return 'Provide the deck\'s title';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Title',
      ),
      textCapitalization: TextCapitalization.sentences,
      maxLength: 32,
    );

    final groupTextField = TextFormField(
      controller: groupTextCtrl,
      validator: (text) {
        if (text.trim().isEmpty) {
          return 'Obligatory field';
        }
        try {
          final input = int.parse(text);
          if (input <= 2 || input > 10) {
            return 'Sessions are a number between 3 and 10';
          }
        } on FormatException {
          return 'Sessions should be a positive number';
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.help_outline),
          tooltip: 'What is a session?',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Boxes and sessions'),
                  content: SingleChildScrollView(
                    child: Text(sessionExplanationMessage),
                  ),
                );
              },
            );
          },
        ),
        labelText: 'Sessions',
      ),
      keyboardType: TextInputType.number,
      maxLength: 2,
    );

    final textFields = ListView(
      primary: false,
      padding: const EdgeInsets.all(10.0),
      children: <Widget>[
        titleTextField,
        groupTextField,
      ],
    );

    final form = Form(
      key: _formValidator,
      child: textFields,
    );

    final appBar = AppBar(
      title: Text('New Deck'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          tooltip: 'Create deck',
          onPressed: () async {
            if (_formValidator.currentState.validate()) {
              await widget.deckRepository.store(Deck(
                null,
                titleTextCtrl.text.trim(),
                int.parse(groupTextCtrl.text.trim()),
              ));
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );

    final scaffold = Scaffold(
      appBar: appBar,
      body: form,
    );

    return scaffold;
  }

  @override
  void dispose() {
    groupTextCtrl.dispose();
    titleTextCtrl.dispose();
    super.dispose();
  }
}
