import 'package:flutter/material.dart';
import 'package:lama_frontend/date-item.dart';
import 'package:lama_frontend/word-dialog.dart';
import 'package:lama_frontend/word-item.dart';
import './app-theme.dart';
import './word.dart';
import 'package:dio/dio.dart';
import './word-response.dart';

void main() => runApp(MyApp());

final String apiServer = 'http://0b868d5e.ngrok.io/api/v1';
// final String apiServer = 'http://172.19.0.1:8080/api/v1';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lama',
      theme: ThemeData(
        primarySwatch: AppTheme.mainMaterial,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return AfterSplash();
  }
}

class AfterSplash extends StatefulWidget {
  AfterSplash({Key key}) : super (key: key);
  @override
  _AfterSplash createState() => _AfterSplash();
}

class _AfterSplash extends State<AfterSplash> {
  Map<String, List<Word>> words = {};
  void onSave(oldWord, newWord) async {
    Dio dio = Dio();
    if (oldWord == null) {
      newWord['user_id'] = 'es';
      await dio.post("$apiServer/words", data: newWord);
    } else {
      await dio.put("$apiServer/words/${oldWord.id}", data: newWord);
    }
    fetchWords();
  }

  void onDelete(Word deletingWord) async {
    await Dio().delete("$apiServer/words/${deletingWord.id}");
    fetchWords();
  }

  void openWordDialog(context, Word word) {
    showDialog(
      barrierDismissible: false,
      context: context,

      builder: (BuildContext context) {
        return WordDialog(word: word, onSave: onSave, onDelete: onDelete);
      }
    );
  }

  List<Widget> wordsToItems(Map<String, List<Word>> words, context) {
    List<Widget> items = [];
    words.keys.forEach((date) {
      items.add(DateItem(date));
      items.addAll(
        words[date].map((word) => WordItem(
          word: word,
          mainContext: context,
          onLongPress: openWordDialog
        )).toList()
      );
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AppTheme.logoFile,
          width: 125,
          fit: BoxFit.scaleDown,
        ),
      ),
      body: ListView(
        children: wordsToItems(words, context)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openWordDialog(context, null),
        child: Icon(
          Icons.add,
          color: Colors.white
        )
      )
    );
  }

  fetchWords() async {
    print('fetching');
    Response rawResponse = await Dio().get("$apiServer/words");
    print('fetched');
    print(rawResponse);
    WordResponse response = WordResponse.fromJson(rawResponse.data);
    response.result.sort((a, b) =>  (b.createdAt.compareTo(a.createdAt)));
    Map<String, List<Word>> tempWords = {};
    response.result.forEach((word) {
      if (tempWords[word.formatedCreatedDate] == null) {
        tempWords[word.formatedCreatedDate] = [];
      }
      tempWords[word.formatedCreatedDate].add(word);
    });
    setState(() {
      words = tempWords;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWords();
  }
}
