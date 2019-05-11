import 'package:flutter/material.dart';

import 'widgets/dash_divider.dart';
import '../presenters/new_flashcard_bloc.dart';

class NewFlashcardPage extends StatefulWidget {
  @override
  _NewFlashcardPageState createState() => _NewFlashcardPageState();
}

class _NewFlashcardPageState extends State<NewFlashcardPage> {
  NewFlashcardBloc _newFlashcardBloc;

  @override
  void initState() {
    super.initState();
    _newFlashcardBloc = NewFlashcardBloc();
  }

  @override
  void dispose() {
    _newFlashcardBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frontAndBack = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Frente',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 24.0,
          ),
        ),
        DashDivider(),
        Text(
          'Trás',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 24.0,
          ),
        ),
      ],
    );

    final scaffold = Scaffold(
      appBar: AppBar(
        title: const Text('Nova carta'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          ),
        ],
      ),
      body: frontAndBack,
    );

    return scaffold;
  }
}

