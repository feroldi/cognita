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
        child: Icon(Icons.add),
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
            itemBuilder: (ctx, index) {
              return ListTile(
                leading:
                    Icon(Icons.folder, color: Theme.of(context).accentColor),
                title: Text(state.decks[index].title),
                onTap: () => _onEditDeck(ctx, state.decks[index]),
              );
            },
            itemCount: state.decks.length,
          );
        }
      },
    );
  }

  void _onCreateDeck(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          CreateDeckPage(widget.deckRepository),
    ));
    homeBloc.dispatch(LoadDecksHomeEvent());
  }

  void _onEditDeck(BuildContext context, Deck deck) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          EditDeckPage(deck, widget.flashcardRepository),
    ));
    homeBloc.dispatch(LoadDecksHomeEvent());
  }

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc(widget.deckRepository)..dispatch(LoadDecksHomeEvent());
  }

  @override
  void dispose() {
    homeBloc.dispose();
    super.dispose();
  }
}
