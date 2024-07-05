import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kwizz/models/Category/category_model.dart';
import 'package:http/http.dart' as http;

class CategoryProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  List<TriviaCategory> _categories = [];
  List<TriviaCategory> get categories => _categories;

  CategoryProvider() {
    http.get(Uri.parse("https://opentdb.com/api_category.php")).then((res) {
      List tempList = (jsonDecode(res.body)['trivia_categories']);
      _categories.addAll(tempList.map((ele) => TriviaCategory.fromMap(ele)));
      _categories.insert(0, TriviaCategory(id: -1, name: "Any Category"));
      notifyListeners();
    });
  }
}
