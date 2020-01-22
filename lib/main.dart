import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  void _onAddButtonClick() {
    // setState(() {
    //   _counter++;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // build() is like render()
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
        onPressed: _onAddButtonClick,
        child: Icon(
          Icons.add,
          color: Colors.white
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
