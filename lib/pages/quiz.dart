import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kwizz/Theme/theme_provider.dart';
import 'package:kwizz/models/Question/question_model.dart';
import 'package:http/http.dart' as http;
import 'package:kwizz/pages/game_over.dart';
import 'package:provider/provider.dart';

class Quiz extends StatefulWidget {
  final String url;
  const Quiz({super.key, required this.url});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<QuestionModel> questions = [];
  QuestionModel? currentQuestion;

  Map<int, bool> score = {};
  Map<int, String> selectedOptions = {};

  bool loading = true;

  int currentQuestionIndex = 0;

  bool isGameOver = false;

  late Timer timer;
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    fetchQuestions(widget.url);
    stopwatch = Stopwatch();
    stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  void fetchQuestions(String url) async {
    var response = await http.get(Uri.parse(url));
    var dataMap = jsonDecode(response.body);
    List<dynamic> data = dataMap['results'];
    for (var element in data) {
      questions.add(QuestionModel.fromMap(element));
    }
    setState(() {
      currentQuestion = questions[currentQuestionIndex];
      loading = false;
    });
  }

  void checkAnswerAndIncrementIndex(String option) {
    if (!loading &&
        currentQuestion != null &&
        score[currentQuestionIndex] == null) {
      score[currentQuestionIndex] = option == currentQuestion!.correct_answer;
      selectedOptions[currentQuestionIndex] = option;
    }
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        currentQuestion = questions[currentQuestionIndex];
      });
    } else {
      setState(() {
        isGameOver = true;
      });
      timer.cancel();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => GameOver(
          score: score,
          questions: questions,
          selectedOptions: selectedOptions,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 500
                      ? 500
                      : MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Text(
                        "${((stopwatch.elapsed.inSeconds) ~/ 60).toString().padLeft(2, "0")} : ${((stopwatch.elapsed.inSeconds) % 60).toString().padLeft(2, "0")}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      Text("${currentQuestionIndex + 1} / ${questions.length}"),
                      Text(
                        currentQuestion!.question,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 350,
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: currentQuestion!.options.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 426 ? 2 : 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio:
                                MediaQuery.of(context).size.width > 426
                                    ? 100 / 25
                                    : 100 / 20,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => checkAnswerAndIncrementIndex(
                                  currentQuestion!.options[index]),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Provider.of<ThemeProvider>(context)
                                            .isDarkMode
                                        ? Colors.white12
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    currentQuestion!.options[index],
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
