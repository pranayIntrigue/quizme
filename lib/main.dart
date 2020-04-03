import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:confetti/confetti.dart';
import 'quizbrain.dart';

//IMPORT THE BANK OF QUESTIONS
QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizme());

class Quizme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = []; // Array definition
  ConfettiController _controllerCenter =
      ConfettiController(duration: const Duration(seconds: 5));

  void checkAnswer(bool userInput) {
    bool correctAnswer = quizBrain.getAnswer();
    if (correctAnswer == userInput) {
      scoreKeeper.add(Icon(
        Icons.check,
        color: Colors.green,
      ));
      _controllerCenter.play();
    } else {
      scoreKeeper.add(Icon(
        Icons.close,
        color: Colors.red,
      ));
    }
    quizBrain.nextQuestion();
    if (quizBrain.isFinished()) {
      Alert(
        context: context,
        title: "Game Over !",
        desc: "Thanks for playing.",
        buttons: [
          DialogButton(
            child: Text(
              "Play Again!",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
      quizBrain.reset();
      scoreKeeper = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ConfettiWidget(
          confettiController: _controllerCenter,
          blastDirectionality: BlastDirectionality
              .explosive, // don't specify a direction, blast randomly
          emissionFrequency: 0.05,
          numberOfParticles: 10,
          gravity: 0.7,
          shouldLoop: false, // start again as soon as the animation is finished
          colors: [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ], // manually specify the colors to be used
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                setState(() {
                  checkAnswer(true);
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                setState(() {
                  checkAnswer(false);
                });
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}
