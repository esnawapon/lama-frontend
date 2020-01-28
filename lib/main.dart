import 'package:flutter/material.dart';
import 'package:lama_frontend/authentication.dart';
import 'package:lama_frontend/date-item.dart';
import 'package:lama_frontend/word-dialog.dart';
import 'package:lama_frontend/word-item.dart';
import './app-theme.dart';
import './word.dart';
import 'package:dio/dio.dart';
import './word-response.dart';
import './constants.dart';

void main() => runApp(MyApp());

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
  Authentication auth;
  Map<String, List<Word>> words = {};
  void onSave(oldWord, newWord) async {
    Dio dio = Dio();
    if (oldWord == null) {
      newWord['user_id'] = 'es';
      await dio.post("${Constants.apiServer}/words/", data: newWord, options: this.auth.getCredentialOption());
    } else {
      await dio.put("${Constants.apiServer}/words/${oldWord.id}", data: newWord, options: this.auth.getCredentialOption());
    }
    fetchWords();
  }

  void onDelete(Word deletingWord) async {
    await Dio().delete("${Constants.apiServer}/words/${deletingWord.id}", options: this.auth.getCredentialOption());
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
    print('fetching...');
    Response rawResponse = await Dio().get("${Constants.apiServer}/words/", options: this.auth.getCredentialOption());
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

  Future login() async {
    print("Authenticating...");
    this.auth = Authentication(Constants.credential);
    await this.auth.fetchAuthToken();
    print("Got User Token");
  }

  @override
  void initState() {
    super.initState();
    login().then((r) {
      fetchWords();
    });
  }
}
