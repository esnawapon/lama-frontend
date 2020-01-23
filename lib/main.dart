import 'package:flutter/material.dart';
import './app-theme.dart';
import './word.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

final String apiServer = 'http://203.114.69.67:8080/api/v1';

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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // build() is like render()
    return AfterSplash();
  }
}

class AfterSplash extends StatefulWidget {
  AfterSplash({Key key}) : super (key: key);

  @override
  _AfterSplash createState() => _AfterSplash();
}

class _AfterSplash extends State<AfterSplash> {
  TextEditingController wordCtrl = TextEditingController();
  TextEditingController definitionCtrl = TextEditingController();
  TextEditingController quoteCtrl = TextEditingController();

  bool isFormValid = false;
  Word data = Word();
  List<Word> words = [Word(id: 1, word: 'test1', definition: 'test2', quote: 'test3')];
  final _newWordFormKey = GlobalKey<FormState>();
  void _onSave(context) async {
    if (_newWordFormKey.currentState.validate()) {
      _newWordFormKey.currentState.save();
      // var response = await http.post("$apiServer/words", body: data);
      setState(() {
        words.insert(0, data);
        data = Word();
      });
      Navigator.of(context).pop();
    }
  }

  void validateForm(_setState) {
    bool isValid = wordCtrl.text.isNotEmpty;
    if (isFormValid != isValid) {
      _setState(() {
        isFormValid = wordCtrl.text.isNotEmpty;
      });
    }
  }

  void swap1(_setState) {
    String temp1 = wordCtrl.text;
    String temp2 = definitionCtrl.text;
    if (temp2.isEmpty) {
      wordCtrl.clear();
    } else {
      wordCtrl.text = temp2;
    }

    if (temp1.isEmpty) {
      definitionCtrl.clear();
    } else {
      definitionCtrl.text = temp1;
    }
    validateForm(_setState);
  }

  void swap2() {
    String temp1 = definitionCtrl.text;
    String temp2 = quoteCtrl.text;
    if (temp2.isEmpty) {
      definitionCtrl.clear();
    } else {
      definitionCtrl.text = temp2;
    }

    if (temp1.isEmpty) {
      quoteCtrl.clear();
    } else {
      quoteCtrl.text = temp1;
    }
  }

  void _onOpenDialog(context, Word word) {
    String title = word == null ? 'New word' : 'Edit my word';
    if (word != null) wordCtrl.text = word.word;
    else wordCtrl.clear();
    if (word != null && word.definition != null) definitionCtrl.text = word.definition;
    else definitionCtrl.clear();
    if (word != null && word.quote != null) quoteCtrl.text = word.quote;
    else quoteCtrl.clear();
    validateForm(setState);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, _setState) {
            return AlertDialog(
              title: new Text(title),
              content: Form(
                key: _newWordFormKey,
                child: Container(
                  height: 250,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Word'
                        ),
                        validator: (value) {
                          return value.isEmpty ? 'required' : null;
                        },
                        onChanged: (value) {
                          validateForm(_setState);
                        },
                        onSaved: (value) {
                          data.word = value;
                        },
                        controller: wordCtrl,
                      ),
                      Container (
                        child: word == null ? null : IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.swap_vert),
                          onPressed: () {
                            swap1(_setState);
                          },
                        )
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Definition'
                        ),
                        onSaved: (value) {
                          data.definition = value;
                        },
                        controller: definitionCtrl
                      ),
                      Container (
                        child: word == null ? null : IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.swap_vert),
                          onPressed: () {
                            swap2();
                          },
                        )
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Quote'
                        ),
                        onSaved: (value) {
                          data.quote = value;
                        },
                        controller: quoteCtrl
                      )
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('CLOSE'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('SAVE'),
                  onPressed: isFormValid ? () => _onSave(context) : null,
                )
              ],
            );
          }
        );
      }
    );
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
        children: words.map((word) => word.toItem(_onOpenDialog, context)).toList()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onOpenDialog(context, null),
        child: Icon(
          Icons.add,
          color: Colors.white
        ),
      ),
    );
  }
}
