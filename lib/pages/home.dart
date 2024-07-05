import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwizz/models/Category/category_model.dart';
import 'package:kwizz/models/Category/category_provider.dart';
import 'package:kwizz/Theme/theme_provider.dart';
import 'package:kwizz/pages/quiz.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TriviaCategory selectedTriviaCategory = TriviaCategory(
    id: -1,
    name: "Any Category",
  );
  int selectedTriviaCategoryId = -1;
  late TextEditingController categoryController;

  double difficulty = 1;
  Map<int, String> difficultyMap = {0: "Easy", 1: "Medium", 2: "Hard"};

  int numberOfQuestions = 10;

  @override
  void initState() {
    categoryController =
        TextEditingController(text: selectedTriviaCategory.name);
    super.initState();
  }

  void handleClick() {
    String url;
    if (selectedTriviaCategoryId == -1) {
      url =
          "https://opentdb.com/api.php?amount=1&difficulty=${difficultyMap[difficulty]?.toLowerCase()}";
    } else {
      url =
          "https://opentdb.com/api.php?amount=$numberOfQuestions&category=$selectedTriviaCategoryId&difficulty=${difficultyMap[difficulty]?.toLowerCase()}";
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Quiz(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double spacerHeight = min(
        30,
        min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height) /
            10);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Kwizz",
          style: TextStyle(letterSpacing: 5, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.light_mode),
                ),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme(),
                  trackColor: Colors.black12,
                  activeColor: Colors.white12,
                  thumbColor: Colors.blue.shade300,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.dark_mode),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: min(MediaQuery.of(context).size.width, 300),
          child: Column(
            children: [
              SizedBox(height: spacerHeight),
              DropdownMenu<TriviaCategory>(
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                width: min(MediaQuery.of(context).size.width, 300),
                initialSelection: selectedTriviaCategory,
                controller: categoryController,
                requestFocusOnTap: true,
                trailingIcon: const Icon(Icons.arrow_drop_down_rounded),
                selectedTrailingIcon: const Icon(Icons.arrow_drop_up_rounded),
                menuHeight: 400,
                dropdownMenuEntries: Provider.of<CategoryProvider>(context)
                    .categories
                    .map(
                      (ele) => DropdownMenuEntry(
                        value: ele,
                        label: ele.name,
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  if (value!.id != -1) {
                    setState(() {
                      selectedTriviaCategoryId = value.id;
                    });
                  }
                },
              ),
              SizedBox(height: spacerHeight),
              Slider(
                thumbColor: Colors.blue.shade400,
                activeColor: Colors.blue.shade400,
                min: 0,
                max: 2,
                divisions: 2,
                value: difficulty,
                onChanged: (val) {
                  setState(() {
                    difficulty = val;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      difficultyMap.values.map((ele) => Text(ele)).toList(),
                ),
              ),
              SizedBox(height: spacerHeight),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: numberOfQuestions > 5
                          ? () {
                              setState(() {
                                numberOfQuestions -= 5;
                              });
                            }
                          : null,
                      icon: const Icon(
                        Icons.remove_rounded,
                      ),
                    ),
                    Text(
                      "$numberOfQuestions",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          numberOfQuestions += 5;
                        });
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () => handleClick(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !Provider.of<ThemeProvider>(context).isDarkMode
                            ? Colors.blue.shade200
                            : Colors.blue.shade700,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      "Start Quiz",
                      style: TextStyle(
                        color: Provider.of<ThemeProvider>(context).isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
