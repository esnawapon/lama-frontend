import 'package:flutter/material.dart';

class Word {
  String word;
  String definition;
  String quote;
  Word({this.word, this.definition, this.quote});

  Container toItem() {
    return Container(
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
            Text(word,
              style: TextStyle(
                color: Color(0xFF546E7A),
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            ),
            Text(definition,
              style: TextStyle(
                color: Color(0xFF546E7A),
              )
            ),
            Text(quote,
              style: TextStyle(
                color: Color(0xFF546E7A),
              )
            ),
          ],
        ),
      )
    );
  }
}
