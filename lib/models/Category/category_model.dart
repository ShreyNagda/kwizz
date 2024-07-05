// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TriviaCategory {
  int id;
  String name;
  TriviaCategory({
    required this.id,
    required this.name,
  });
  TriviaCategory? getCategory(int id) {
    if (id == id) {
      return this;
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory TriviaCategory.fromMap(Map<String, dynamic> map) {
    return TriviaCategory(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TriviaCategory.fromJson(String source) =>
      TriviaCategory.fromMap(json.decode(source) as Map<String, dynamic>);
}
