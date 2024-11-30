import 'dart:math';
import 'package:flutter/material.dart';

class WordPuzzleScreen extends StatefulWidget {
  @override
  _WordPuzzleScreenState createState() => _WordPuzzleScreenState();
}

class _WordPuzzleScreenState extends State<WordPuzzleScreen> {
  List<Offset> dragPositions = [];
  String selectedWord = "";
  int currentQuestionIndex = 0;
  final List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'image': 'assets/team.jpg',
      'letters': ["T", "E", "A", "M"],
      'correctWord': "TEAM"
    },
    {
      'id': 2,
      'image': 'assets/bat.jpg',
      'letters': ["B", "T", "A", "S"],
      'correctWord': "BATS"
    },
    {
      'id': 3,
      'image': 'assets/cats.jpg',
      'letters': ["C", "A", "S", "T"],
      'correctWord': "CATS"
    },
    {
      'id': 4,
      'image': 'assets/dogs.jpg',
      'letters': ["O", "D", "S", "G"],
      'correctWord': "DOGS"
    },
    {
      'id': 5,
      'image': 'assets/ball.jpg',
      'letters': ["L", "L", "B", "A"],
      'correctWord': "BALL"
    },
  ];

  final double radius = 100.0;

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final deviceWidth = MediaQuery.of(context).size.width;


    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7971B3).withOpacity(0.6), Color(0xFF453D7E).withOpacity(0.9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black,size: 30,),

              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Word Puzzle', style: TextStyle(color: Colors.black, fontSize: 24,fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: Center(
            child: Container(
              width: deviceWidth*0.8,
              padding: EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white24, Colors.white70],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.lightBlueAccent.withOpacity(0.7), Colors.lightBlueAccent.withOpacity(0.1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.asset(
                          currentQuestion['image'],
                          height: 150,
                        ),
                        SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Click here to hear the spelling',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black54),
                            ),
                            IconButton(
                              icon: Icon(Icons.volume_up),
                              onPressed: () {
                                // Add sound logic
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Use these letters to know what’s in the image!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            dragPositions.add(details.localPosition);
                          });
                        },
                        onPanEnd: (_) {
                          setState(() {
                            selectedWord = generateWord(dragPositions);
                            dragPositions.clear();
                            if (selectedWord == currentQuestion['correctWord']) {
                              _showSuccessDialog();
                            } else {
                              _showHintDialog();
                            }
                          });
                        },
                        child: CustomPaint(
                          size: Size(300, 300),
                          painter: LetterCirclePainter(
                            letters: currentQuestion['letters'],
                            positions: dragPositions,
                            radius: radius,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Selected Word: $selectedWord',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have guessed the word correctly!'),
          actions: [
            TextButton(
              child: Text('Next Word'),
              onPressed: () {
                setState(() {
                  currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
                  selectedWord = "";
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showHintDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keep Trying!'),
          content: Text('Try again, you\'re almost there!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String generateWord(List<Offset> dragPositions) {
    String word = "";
    for (var position in dragPositions) {
      for (int i = 0; i < questions[currentQuestionIndex]['letters'].length; i++) {
        final letterPos = getLetterPosition(i);
        if ((position - letterPos).distance < 40) {
          if (!word.contains(questions[currentQuestionIndex]['letters'][i])) {
            word += questions[currentQuestionIndex]['letters'][i];
          }
        }
      }
    }
    return word;
  }

  Offset getLetterPosition(int index) {
    final angle = 2 * pi * index / questions[currentQuestionIndex]['letters'].length;
    final center = Offset(150, 150);
    return Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );
  }
}

class LetterCirclePainter extends CustomPainter {
  final List<String> letters;
  final List<Offset> positions;
  final double radius;

  LetterCirclePainter({
    required this.letters,
    required this.positions,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, Paint()..color = Colors.white70);

    for (int i = 0; i < letters.length; i++) {
      final angle = 2 * pi * i / letters.length;
      final offset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      final textPainter = TextPainter(
        text: TextSpan(
          text: letters[i],
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(offset.dx - textPainter.width / 2, offset.dy - textPainter.height / 2),
      );
    }
    final linePaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < positions.length - 1; i++) {
      canvas.drawLine(positions[i], positions[i + 1], linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
