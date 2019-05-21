import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import '../model/deck.dart';
import '../repository/deck_repository.dart';
import '../repository/flashcard_repository.dart';
import '../ui/create_deck_page.dart';
import '../ui/edit_deck_page.dart';

class HomePage extends StatefulWidget {
  final DeckRepository deckRepository;
  final FlashcardRepository flashcardRepository;

  HomePage(this.deckRepository, this.flashcardRepository);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc homeBloc;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Cognita'),
    );

    final scaffold = Scaffold(
      appBar: appBar,
      body: _buildDeckList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _onCreateDeck(context),
        child: Icon(Icons.library_add),
      ),
    );

    return scaffold;
  }

  Widget _buildDeckList(BuildContext context) {
    return BlocBuilder<HomeEvent, HomeState>(
      bloc: homeBloc,
      builder: (context, state) {
        if (state is LoadingHomeState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is DecksHomeState) {
          if (state.decks.isEmpty) {
            return Center(
              child: Text(
                'Empty',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontSize: 24.0),
              ),
            );
          }

          return ListView.separated(
            separatorBuilder: (ctx, index) => Divider(height: 0.0),
            itemBuilder: (ctx, index) =>
                _buildDeckTile(ctx, state.decks[index]),
            itemCount: state.decks.length,
          );
        }
      },
    );
  }

  Widget _buildDeckTile(BuildContext context, Deck deck) {
    final tile = ListTile(
      leading: Icon(Icons.library_books, color: Theme.of(context).accentColor),
      title: Text(deck.title),
      onTap: () => _onEditDeck(context, deck),
    );

    return Dismissible(
      key: Key('deck ${deck.id}'),
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
      onDismissed: (direction) => _onDeckDismissed(deck, direction),
      confirmDismiss: (direction) =>
          _confirmDeckDismiss(context, direction, deck),
    );
  }

  void _onDeckDismissed(Deck deck, DismissDirection direction) async {
    await widget.deckRepository.remove(deck.id);
    homeBloc.dispatch(HomeEventDeleteDeck(deck));
  }

  Future<bool> _confirmDeckDismiss(
      BuildContext context, DismissDirection direction, Deck deck) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Delete ${deck.title}?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('This will remove this deck and its flashcards.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
            FlatButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
          ],
        );
      },
    );
  }

  void _onCreateDeck(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CreateDeckPage(widget.deckRepository),
    ));
    homeBloc.dispatch(LoadDecksHomeEvent());
  }

  void _onEditDeck(BuildContext context, Deck deck) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditDeckPage(deck, widget.flashcardRepository),
    ));
    homeBloc.dispatch(LoadDecksHomeEvent());
  }

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc(widget.deckRepository, widget.flashcardRepository)
      ..dispatch(LoadDecksHomeEvent());
  }

  @override
  void dispose() {
    homeBloc.dispose();
    super.dispose();
  }
}
