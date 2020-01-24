import 'package:flutter/material.dart';
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

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
  TextEditingController wordCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController quoteCtrl = TextEditingController();

  bool isFormValid = false;
  Word data = Word();
  Map<String, List<Word>> words = {};
  final _form = GlobalKey<FormState>();
  void onSave(context, Word edittingWord) async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      var body = {
        'word': data.word,
        'description': data.description,
        'quote': data.quote
      };
      Dio dio = Dio();
      if (edittingWord == null) {
        body['user_id'] = 'es';
        await dio.post('${apiServer}/words', data: body);
      } else {
        await dio.put('${apiServer}/words/${edittingWord.id}', data: body);
      }
      Navigator.of(context).pop();
      fetchWords();
    }
  }

  void onDelete(context, Word deletingWord) async {
    await Dio().delete('${apiServer}/words/${deletingWord.id}');
    Navigator.of(context).pop();
    fetchWords();
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
    String temp2 = descriptionCtrl.text;
    if (temp2.isEmpty) {
      wordCtrl.clear();
    } else {
      wordCtrl.text = temp2;
    }

    if (temp1.isEmpty) {
      descriptionCtrl.clear();
    } else {
      descriptionCtrl.text = temp1;
    }
    validateForm(_setState);
  }

  void swap2() {
    String temp1 = descriptionCtrl.text;
    String temp2 = quoteCtrl.text;
    if (temp2.isEmpty) {
      descriptionCtrl.clear();
    } else {
      descriptionCtrl.text = temp2;
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
    if (word != null && word.description != null) descriptionCtrl.text = word.description;
    else descriptionCtrl.clear();
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
                key: _form,
                child: Container(
                  height: 300,
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
                          data.description = value;
                        },
                        controller: descriptionCtrl
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 50,
                            child: word == null ? Container() : FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Text('DELETE',
                                style: TextStyle(
                                  color: Colors.red
                                )
                              ),
                              onPressed: () => onDelete(context, word)
                            )
                          ),
                          Container(
                            width: 50,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Text('CLOSE',
                                  style: TextStyle(
                                  color: AppTheme.mainColor
                                )
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ),
                          Container(
                            width: 50,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Text('SAVE',
                                style: TextStyle(
                                  color: isFormValid ? AppTheme.mainColor : Colors.grey
                                )
                              ),
                              onPressed: isFormValid ? () => onSave(context, word) : null,
                            )
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }

  List<Widget> wordsToItems(Map<String, List<Word>> words, context) {
    List<Widget> items = [];
    for (String date in words.keys) {
      String formatedDate;
      if (date.indexOf('.') > 0) {
        formatedDate = date.substring(0, date.indexOf('.') + 1);
      } else {
        formatedDate = date;
      }
      items.add(
        Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Text(formatedDate,
            style: TextStyle(
              color: AppTheme.mainColor,
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          )
        )
      );
      var wordsItems = words[date].map((word) => GestureDetector(
        onLongPress: () {
          _onOpenDialog(context, word);
        },
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 20,
            right: 20
          ),
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: const Color(0xFF000000),
              width: 1.0,
              style: BorderStyle.solid
            )
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(word.word,
                    style: TextStyle(
                      color: Color(0xFF546E7A),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(word.description,
                    style: TextStyle(
                      color: Color(0xFF546E7A),
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(word.quote,
                    style: TextStyle(
                      color: Color(0xFF546E7A),
                    )
                  ),
                ),
              ],
            ),
          )
        )
      )).toList();
      items.addAll(wordsItems);
    }
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
        onPressed: () => _onOpenDialog(context, null),
        child: Icon(
          Icons.add,
          color: Colors.white
        ),
      ),
    );
  }

  fetchWords() async {
    Response rawResponse = await Dio().get('${apiServer}/words');
    WordResponse response = WordResponse.fromJson(rawResponse.data);
    response.result.sort((a, b) =>  (b.createdAt.compareTo(a.createdAt)));
    Map<String, List<Word>> tempWords = {};
    for (Word word in response.result) {
      if (tempWords[word.formatedCreatedDate] == null) {
        tempWords[word.formatedCreatedDate] = [];
      }
      tempWords[word.formatedCreatedDate].add(word);
    }
    setState(() {
      words = tempWords;
    });
  }

  @override
  void initState() {
    fetchWords();
  }
}
