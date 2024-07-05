// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:html_unescape/html_unescape.dart';

class QuestionModel {
  String type;
  String difficulty;
  String category;
  String question;
  String correct_answer;
  List<dynamic> incorrect_answers;
  List<dynamic> options;
  QuestionModel({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correct_answer,
    required this.incorrect_answers,
    required this.options,
  });
  bool checkAnswer(String option) {
    return option == correct_answer;
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    HtmlUnescape unescape = HtmlUnescape();
    List<dynamic> tempOptionsList = [];
    List<dynamic> allOptionsList = [];
    for (var i in map["incorrect_answers"]) {
      tempOptionsList.add(unescape.convert(i.toString()));
    }
    allOptionsList.addAll(tempOptionsList);
    allOptionsList.add(unescape.convert(map["correct_answer"].toString()));

    allOptionsList.shuffle();

    return QuestionModel(
      type: map["type"],
      difficulty: map["difficulty"],
      category: unescape.convert(map["category"]),
      question: unescape.convert(map["question"]),
      correct_answer: unescape.convert(map["correct_answer"].toString()),
      incorrect_answers: tempOptionsList,
      options: allOptionsList,
    );
  }
}
