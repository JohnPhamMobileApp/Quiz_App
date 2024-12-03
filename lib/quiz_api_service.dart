import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizApiService {
  static const String baseUrl = 'https://opentdb.com/api.php';

  // Fetch quiz questions from Open Trivia Database
  static Future<List<Question>> fetchQuizQuestions(
      int numberOfQuestions,
      String category,
      String difficulty,
      String questionType) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl?amount=$numberOfQuestions&category=$category&difficulty=$difficulty&type=$questionType'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['results'];
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load quiz questions');
    }
  }
}

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> incorrectAnswers = List<String>.from(json['incorrect_answers']);
    incorrectAnswers.add(json['correct_answer']);
    incorrectAnswers.shuffle();

    return Question(
      question: json['question'],
      options: incorrectAnswers,
      correctAnswer: json['correct_answer'],
    );
  }
}
