import 'package:flutter/material.dart';
import '../utils/question.dart';
import '../utils/quiz.dart';

import '../UI//answer_button.dart';
import '../UI/question_text.dart';
import '../UI/corret_wrong_overlay.dart';

import './score_page.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  Question currentQuestion;
  Quiz quiz = Quiz([
    Question("Elon Musk is human", false),
    Question("Pizza is healthy", false),
    Question("Flutter is awesome", true),
  ]);

  String questionText;
  int questionNumber;
  bool isCorret;
  bool overlayShouldBeVisible = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    isCorret = (currentQuestion.answer == answer);
    quiz.answer(isCorret);
    this.setState(() {
      overlayShouldBeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          // This is our main page.
          children: <Widget>[
            AnswerButton(true, () => handleAnswer(true)),
            QuestionText(questionText, questionNumber),
            AnswerButton(false, () => handleAnswer(false)),
          ],
        ),
        overlayShouldBeVisible == true ? CorrectWrongOverlay(
          isCorret,
          () {
            if (quiz.length == questionNumber) {
              Navigator.of(context).pushAndRemoveUntil (
                MaterialPageRoute(
                  builder: (BuildContext context) => 
                  ScorePage(quiz.score, quiz.length)
                  ),
                  (Route route) => route == null
                  );
              return;
            }

            currentQuestion = quiz.nextQuestion;
            this.setState(() {
              overlayShouldBeVisible = false;
              questionText = currentQuestion.question;
              questionNumber = quiz.questionNumber;
            });
          }
          ) : Container()
      ],
    );
  }
}
