import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/flashcard.dart';
import '../repository/flashcard_repository.dart';

class NewFlashcardBloc extends Bloc<NewFlashcardEvent, NewFlashcardState> {
  final FlashcardRepository flashcardRepository;

  NewFlashcardBloc({@required this.flashcardRepository});

  @override
  NewFlashcardState get initialState => UninitNewFlashcardState();

  @override
  Stream<NewFlashcardState> mapEventToState(NewFlashcardEvent event) async* {
    if (event is QuestionButtonPressed) {
      yield currentState.copyWith(question: event.text);
    }

    if (event is AnswerButtonPressed) {
      yield currentState.copyWith(answer: event.text);
    }

    if (event is SaveButtonPressed) {
      if (currentState.isComplete) {
        final flashcard = Flashcard(
          question: currentState.question,
          answer: currentState.answer,
        );
        flashcardRepository.save(flashcard);
      }
    }
  }
}

abstract class NewFlashcardEvent {}

class SaveButtonPressed implements NewFlashcardEvent {}

class QuestionButtonPressed implements NewFlashcardEvent {
  final String text;
}

class AnswerButtonPressed implements NewFlashcardEvent {
  final String text;
}

class NewFlashcardState {
  final String question;
  final String answer;

  bool get isComplete =>
      question != null &&
      question.isNotEmpty &&
      answer != null &&
      answer.isNotEmpty;

  NewFlashcardState copyWith({String question, final String answer}) => NewFlashcardState(
        question: question ?? this.question,
        answer: answer ?? this.answer,
      );
}
