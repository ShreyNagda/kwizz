// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kwizz/Theme/theme_provider.dart';

import 'package:kwizz/models/Question/question_model.dart';
import 'package:provider/provider.dart';

class GameOver extends StatefulWidget {
  final Map<int, bool> score;
  final List<QuestionModel> questions;
  final Map<int, String> selectedOptions;
  const GameOver({
    super.key,
    required this.score,
    required this.questions,
    required this.selectedOptions,
  });

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  int score = 0;

  late List<QuestionModel> questions;
  late Map<int, String> selectedOptions;

  @override
  void initState() {
    questions = widget.questions;
    selectedOptions = widget.selectedOptions;
    for (var ele in widget.score.values) {
      if (ele == true) {
        score++;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 500
              ? 500
              : MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "Game Over",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text("Your Score: $score"),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: () {}, child: const Text("Play Again")),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Text(
                            "${index + 1}. ${questions[index].question}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 300,
                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount:
                                    MediaQuery.of(context).size.width > 500
                                        ? 2
                                        : 1,
                                childAspectRatio:
                                    MediaQuery.of(context).size.width > 426
                                        ? 50 / 12.5
                                        : 50 / 10,
                              ),
                              children: questions[index]
                                  .options
                                  .map((option) => Container(
                                        decoration: BoxDecoration(
                                            color: option ==
                                                    questions[index]
                                                        .correct_answer
                                                ? Colors.greenAccent
                                                : option ==
                                                        selectedOptions[index]
                                                    ? Colors.red
                                                    : Provider.of<ThemeProvider>(
                                                                context)
                                                            .isDarkMode
                                                        ? Colors.white12
                                                        : Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            option,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
