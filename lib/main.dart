import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import './app-theme.dart';

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
    return SplashScreen(
      seconds: 1,
      navigateAfterSeconds: AfterSplash(),
      image: Image.asset(
        AppTheme.logoBgFile,
        fit: BoxFit.cover,
      ),
      backgroundColor: Colors.white,
      photoSize: 75.0,
      loaderColor: Colors.white
    );
  }
}

class AfterSplash extends StatefulWidget {
  AfterSplash({Key key}) : super (key: key);

  @override
  _AfterSplash createState() => _AfterSplash();
}

class _AfterSplash extends State<AfterSplash> {
  bool isFormValid = false;
  final _newWordFormKey = GlobalKey<FormState>();
  void _onSave() {
    if (_newWordFormKey.currentState.validate()) {
      // call api to save
    } else {
      // do nothing
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
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Definition'
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Quote'
                        ),
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
                  onPressed: isFormValid ? _onSave : null,
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
      body: Center(
        child: Column(
          children: [
            Text(' '),
            Text(' '),
            Text(' '),
            Text(' '),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddButtonClick(context),
        child: Icon(
          Icons.add,
          color: Colors.white
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
