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
      validator: (text) => text.trim().isEmpty ? '' : null,
      decoration: InputDecoration(
        labelText: 'Title',
      ),
    );

    final groupTextField = TextFormField(
      controller: groupTextCtrl,
      validator: (text) => text.trim().isEmpty ? '' : null,
      decoration: InputDecoration(
        labelText: 'Sessions',
      ),
      keyboardType: TextInputType.number,
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
                titleTextCtrl.text,
                int.parse(groupTextCtrl.text),
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
