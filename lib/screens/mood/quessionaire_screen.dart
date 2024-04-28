import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_companion_app/screens/app_shell.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:health_companion_app/models/quessionaire.dart';

class QuessionaireScreen extends StatefulWidget {
  const QuessionaireScreen({super.key});

  @override
  State<QuessionaireScreen> createState() => _QuessionaireScreenState();
}

class _QuessionaireScreenState extends State<QuessionaireScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xC71D3434),
        child: Align(
          alignment: Alignment.center,
          child: FutureBuilder<Task>(
            future: Quessionaire.getQuessionaire(),
            builder: (BuildContext context, AsyncSnapshot<Task> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                final Task task = snapshot.data!;
                return SurveyKit(
                  onResult: (SurveyResult result) {
                    if (result.finishReason == FinishReason.COMPLETED) {
                      List<StepResult> answers = result.results.toList();
                      List<List<bool>> scoringScheme = Quessionaire.getAnswers();
                      Map<String, int> scores = {
                        "Depression": 0,
                        "Anxiety": 0,
                        "Stress": 0
                      };
                      answers.removeAt(0);
                      answers.removeAt(answers.length - 1);
                      for (var i = 0; i < answers.length; i++) {
                        int currentAnswer =
                        int.parse(answers[i].results[0].valueIdentifier!);
                        List<bool> scorings = scoringScheme[i];
                        scores["Depression"] = scorings[0]
                            ? scores["Depression"]! + currentAnswer
                            : scores["Depression"]!;
                        scores["Anxiety"] = scorings[1]
                            ? scores["Anxiety"]! + currentAnswer
                            : scores["Anxiety"]!;
                        scores["Stress"] = scorings[2]
                            ? scores["Stress"]! + currentAnswer
                            : scores["Stress"]!;
                      }
                      scores["Depression"] = scores["Depression"]! * 2;
                      scores["Anxiety"] = scores["Anxiety"]! * 2;
                      scores["Stress"] = scores["Stress"]! * 2;

                      List<String> finalResult = [];
                      for (String condition in scores.keys.toList()) {
                        finalResult.add(Quessionaire.getScoringResult(condition, scores[condition]!));
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppShell(currentIndex: 1, dassScores: finalResult)),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppShell(currentIndex: 1)),
                      );
                    }

                  },
                  task: task,
                  showProgress: true,
                  themeData: ThemeData.dark().copyWith(
                    primaryColor: Colors.cyan,
                    appBarTheme: const AppBarTheme(
                      color: Colors.white,
                      iconTheme: IconThemeData(
                        color: Colors.cyan,
                      ),
                      titleTextStyle: TextStyle(
                        color: Colors.cyan,
                      ),
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.cyan,
                    ),
                    textSelectionTheme: const TextSelectionThemeData(
                      cursorColor: Colors.cyan,
                      selectionColor: Colors.cyan,
                      selectionHandleColor: Colors.cyan,
                    ),
                    cupertinoOverrideTheme: const CupertinoThemeData(
                      primaryColor: Colors.cyan,
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                          const Size(150.0, 60.0),
                        ),
                        side: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> state) {
                            if (state.contains(MaterialState.disabled)) {
                              return const BorderSide(
                                color: Colors.grey,
                              );
                            }
                            return const BorderSide(
                              color: Colors.cyan,
                            );
                          },
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        textStyle: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> state) {
                            if (state.contains(MaterialState.disabled)) {
                              return Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Colors.grey,
                                  );
                            }
                            return Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Colors.cyan,
                                );
                          },
                        ),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.cyan,
                              ),
                        ),
                      ),
                    ),
                    textTheme: const TextTheme(
                      displayMedium: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Hind-Regular'),
                      headlineSmall: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                          fontFamily: 'Hind-Regular'),
                      bodyMedium: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontFamily: 'Hind-Regular'),
                      titleMedium: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontFamily: 'Hind-Regular'),
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    colorScheme: ColorScheme.fromSwatch(
                      primarySwatch: Colors.cyan,
                    )
                        .copyWith(
                          onPrimary: Colors.white,
                        )
                        .copyWith(background: Colors.white),
                  ),
                  surveyProgressbarConfiguration: SurveyProgressConfiguration(
                    backgroundColor: Colors.white,
                  ),
                );
              }
              return const CircularProgressIndicator.adaptive();
            },
          ),
        ),
      ),
    );
  }
}
