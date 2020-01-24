import 'package:intl/intl.dart';

class Word {
  String _id;
  String word;
  String description;
  String quote;
  DateTime createdAt;
  DateTime updatedAt;
  Word({
    id,
    this.word,
    this.description,
    this.quote,
    this.createdAt,
    this.updatedAt
  }): this._id = id;

  get formatedCreatedDate {
    if (createdAt == null) {
      return 'N/A';
    }
    return DateFormat('dd MMM. yyyy').format(createdAt).toLowerCase();
  }

  get id => this._id;
}
