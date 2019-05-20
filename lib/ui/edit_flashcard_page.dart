import 'package:flutter/material.dart';

typedef FlashcardCallback = void Function(String question, String answer);

class EditFlashcardPage extends StatefulWidget {
  final String question;
  final String answer;
  final bool isEditing;
  final FlashcardCallback onSaveAction;

  EditFlashcardPage(
    this.question,
    this.answer, {
    this.isEditing = true,
    this.onSaveAction,
  });

  @override
  _EditFlashcardPageState createState() => _EditFlashcardPageState();
}

class _EditFlashcardPageState extends State<EditFlashcardPage> {
  final questionTextCtrl = TextEditingController();
  final answerTextCtrl = TextEditingController();
  final _formValidator = GlobalKey<FormState>();

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    final questionTextField = TextFormField(
      controller: questionTextCtrl,
      validator: (text) => text.trim().isEmpty ? '' : null,
      maxLines: 8,
      decoration: InputDecoration(
        labelText: 'Question',
      ),
      textCapitalization: TextCapitalization.sentences,
      maxLength: 256,
    );

    final answerTextField = TextFormField(
      controller: answerTextCtrl,
      validator: (text) => text.trim().isEmpty ? '' : null,
      maxLines: 8,
      decoration: InputDecoration(
        labelText: 'Answer',
      ),
      textCapitalization: TextCapitalization.sentences,
      maxLength: 256,
    );

    final textFields = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          questionTextField,
          answerTextField,
        ],
      ),
    );

    final form = Form(
      key: _formValidator,
      child: textFields,
    );

    final appBar = AppBar(
      title: Text(isEditing ? 'Edit Flashcard' : 'New Flashcard'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          tooltip: 'Save flashcard',
          onPressed: widget.onSaveAction != null
              ? () {
                  if (_formValidator.currentState.validate()) {
                    widget.onSaveAction(
                      questionTextCtrl.text.trim(),
                      answerTextCtrl.text.trim(),
                    );
                    Navigator.of(context).pop();
                  }
                }
              : null,
        ),
      ],
    );

    final scaffold = Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: form,
      ),
    );

    return scaffold;
  }

  @override
  void initState() {
    super.initState();
    questionTextCtrl.text = widget.question;
    answerTextCtrl.text = widget.answer;
  }

  @override
  void dispose() {
    answerTextCtrl.dispose();
    questionTextCtrl.dispose();
    super.dispose();
  }
}
