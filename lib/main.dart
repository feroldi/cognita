import 'package:flutter/material.dart';

import 'new_card/new_card_page.dart';

// TODO: Dashboard, que dá informação pra tu vagabundo
// TODO: Meus decks, que lista os decks
// TODO: Novo deck, que cria um novo deck
// TODO: Nova carta, que seleciona um deck pra criar card

void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cognita'),
      ),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  // Barra inferior da home
  Widget _buildBottomBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          title: Text('Dashboard'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          title: Text('Nova carta'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          title: Text('Meus decks'),
        ),
      ],
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewCardPage(),
        ),
      );
    }
  }

  Widget _buildBody(BuildContext context) {
    return Container();
  }
}
