# Cognita

Cognita is a flashcard system Flutter application.
It implements the [Leitner system][1] for the training sessions, allowing the user to choose how many sessions a deck should go through.
This is a university mobile development class' homework, so expect to see suboptimal code.

The application data are persisted using an embedded SQLite database.

## Building

Clone the repository and run it with Flutter:

    git clone https://github.com/feroldi/cognita.git
    cd cognita
    flutter run

## Testing

Unfortunately, there aren't any tests written for Cognita.
Feel free to submit a PR if you wish to contribute in any way.

[1]: https://en.wikipedia.org/wiki/Leitner_system
