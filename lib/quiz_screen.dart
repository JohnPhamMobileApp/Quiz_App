import 'package:flutter/material.dart';
import 'quiz_api_service.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> _questions;
  late int _currentQuestionIndex;
  int _score = 0;
  bool _isLoading = true; // Track loading state
  String _feedback = ''; // To store feedback (Correct/Incorrect)

  @override
  void initState() {
    super.initState();
    _currentQuestionIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    // Get the arguments passed from the QuizSetupScreen
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final numberOfQuestions = arguments['numberOfQuestions'];
    final category = arguments['category'];
    final difficulty = arguments['difficulty'];
    final questionType = arguments['questionType'];

    // Fetch the questions if not already fetched
    if (_isLoading) {
      QuizApiService.fetchQuizQuestions(numberOfQuestions, category, difficulty, questionType)
          .then((questions) {
        setState(() {
          _questions = questions;
          _isLoading = false; // Set loading to false after fetching
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        print('Error fetching questions: $error');
      });
    }

    // Show loading indicator while fetching questions
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Main quiz screen when questions are loaded
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display current question index and total number of questions
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // Display the current question text
            Text(_questions[_currentQuestionIndex].question),
            SizedBox(height: 20),

            // Display the feedback ("Correct!" or "Incorrect!")
            if (_feedback.isNotEmpty)
              Text(
                _feedback,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _feedback == 'Correct!' ? Colors.green : Colors.red,
                ),
              ),
            SizedBox(height: 20),

            // Display the options as buttons
            ..._questions[_currentQuestionIndex].options.map((option) {
              return ElevatedButton(
                onPressed: () {
                  // Check if the answer is correct
                  if (option == _questions[_currentQuestionIndex].correctAnswer) {
                    setState(() {
                      _score++;
                      _feedback = 'Correct!'; // Show correct feedback
                    });
                  } else {
                    setState(() {
                      _feedback = 'Incorrect! The correct answer was: ${_questions[_currentQuestionIndex].correctAnswer}';
                    });
                  }

                  // Move to the next question after a short delay (to show feedback)
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      // Check if there are more questions
                      if (_currentQuestionIndex < _questions.length - 1) {
                        _currentQuestionIndex++;
                        _feedback = ''; // Reset feedback for the next question
                      } else {
                        // End of the quiz
                        _showFinalScore();
                      }
                    });
                  });
                },
                child: Text(option),
              );
            }).toList(),

            SizedBox(height: 20),
            // Display the user's score in real-time
            Text(
              'Score: $_score/${_questions.length}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  // Show the final score when the quiz is over
  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Quiz Over'),
        content: Text('Your final score is: $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Optionally, navigate to another screen or reset the quiz
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
