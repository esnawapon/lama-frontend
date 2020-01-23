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
  bool isFormValid = false;
  Word data = Word();
  List<Word> words = [Word(word: 'test1', definition: 'test2', quote: 'test3')];
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

  void _onAddButtonClick(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text('New word'),
              content: Form(
                key: _newWordFormKey,
                child: Container(
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Word'
                        ),
                        validator: (value) {
                          return value.isEmpty ? 'required' : null;
                        },
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              isFormValid = false;
                            });
                          } else {
                            setState(() {
                              isFormValid = true;
                            });
                          }
                        },
                        onSaved: (value) {
                          data.word = value;
                        }
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Definition'
                        ),
                        onSaved: (value) {
                          data.definition = value;
                        }
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Quote'
                        ),
                        onSaved: (value) {
                          data.quote = value;
                        }
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
        children: words.map((word) => word.toItem()).toList()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddButtonClick(context),
        child: Icon(
          Icons.add,
          color: Colors.white
        ),
      ),
    );
  }
}
