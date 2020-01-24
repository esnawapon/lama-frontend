import 'package:lama_frontend/word.dart';

class WordResponse<T> {
  List<Word> result;
  String message;

  WordResponse({this.result, this.message});

  factory WordResponse.fromJson(Map<String, dynamic> parsedJson) {
    return WordResponse(
      result: parsedJson['result'].map<Word>((each) => (
        Word(
          id: each['_id'],
          word: each['word'],
          description: each['description'],
          quote: each['quote'],
          createdAt: each['createdAt'] == null ? null : DateTime.parse(each['createdAt']),
          updatedAt: each['updatedAt'] == null ? null : DateTime.parse(each['updatedAt'])
        )
      )).toList(),
      message: parsedJson['message']
    );
  }
}
