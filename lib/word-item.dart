import 'package:flutter/material.dart';
import 'package:lama_frontend/app-theme.dart';
import 'package:lama_frontend/word.dart';

class WordItem extends StatefulWidget {
  final Word word;
  final BuildContext mainContext;
  final dynamic onLongPress;
  WordItem({
    this.word,
    this.mainContext,
    this.onLongPress
  });

  @override
  _WordItem createState() => _WordItem(
    word,
    mainContext,
    onLongPress
  );
}

class _WordItem extends State<WordItem> {
  Word word;
  BuildContext mainContext;
  dynamic onLongPress;
  bool collapesed = true;

  _WordItem(
    this.word,
    this.mainContext,
    this.onLongPress
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          collapesed = !collapesed;
        });
      },
      onLongPress: () => onLongPress(context, word),
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
            color: Colors.black,
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
                    color: AppTheme.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              collapesed ? Container() : Container(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(word.description,
                        style: TextStyle(
                          color: AppTheme.grey,
                        )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(word.quote,
                        style: TextStyle(
                          color: AppTheme.grey,
                        )
                      ),
                    ),
                  ]
                )
              )
            ]
          )
        )
      )
    );
  }
}
