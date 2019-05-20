import 'package:flutter/material.dart';

import '../model/deck.dart';
import '../repository/deck_repository.dart';

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
            return 'Sessions can only be 3 to 10';
          }
        } on FormatException {
          return 'Sessions are a number between 3 and 10';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Sessions',
      ),
      keyboardType: TextInputType.number,
      maxLength: 2,
    );

    final textFields = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          titleTextField,
          groupTextField,
        ],
      ),
    );

    final form = Form(
      key: _formValidator,
      child: textFields,
    );

    final appBar = AppBar(
      title: Text('New deck'),
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
