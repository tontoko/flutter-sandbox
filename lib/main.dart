import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test app',
      home: const RandomWords(),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("app bar"),
          actions: [
            IconButton(onPressed: _pushSaved, icon: const Icon(Icons.list))
          ],
        ),
        body: _buildSuggestions());
  }

  void _pushSaved() =>
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        final tiles = _saved.map((pair) => Dismissible(
            key: Key(pair.asPascalCase),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() => _saved.remove(pair));
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Column(children: [
                          Text('${pair.asPascalCase} removed!'),
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(),
                              child: const Text("OK")),
                        ], mainAxisSize: MainAxisSize.min),
                      ));
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Column(children: [
                          Text(pair.asPascalCase),
                          TextButton(
                              // onPressed: () => Navigator.pop(context),
                              onPressed: null,
                              style: TextButton.styleFrom(),
                              child: const Text("OK")),
                        ], mainAxisSize: MainAxisSize.min),
                      )),
            )));
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(context: context, tiles: tiles).toList()
            : <Widget>[];

        return Scaffold(
          appBar: AppBar(title: const Text("Saved Suggestions")),
          body: ListView(children: divided),
        );
      }));

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : "save",
      ),
      onTap: () => setState(() {
        if (alreadySaved) {
          _saved.remove(pair);
        } else {
          _saved.add(pair);
        }
      }),
    );
  }
}
