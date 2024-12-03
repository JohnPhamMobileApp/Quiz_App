import 'package:flutter/material.dart';

class QuizSetupScreen extends StatefulWidget {
  @override
  _QuizSetupScreenState createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  int numberOfQuestions = 10;
  String category = '9'; // Default: General Knowledge
  String difficulty = 'easy'; // Default: Easy
  String questionType = 'multiple'; // Default: Multiple Choice

  // List of category names and their corresponding category IDs
  final Map<String, String> categoryMap = {
    'General Knowledge': '9',
    'Entertainment: Film': '11',
    'Entertainment: Music': '12',
    'Entertainment: Video Games': '15',
    'Science: Computers': '18',
    
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Number of Questions'),
            Slider(
              value: numberOfQuestions.toDouble(),
              min: 1,
              max: 50,
              divisions: 49,
              onChanged: (value) {
                setState(() {
                  numberOfQuestions = value.toInt();
                });
              },
            ),
            Text('Category'),
            DropdownButton<String>(
              value: categoryMap.keys.firstWhere(
                  (key) => categoryMap[key] == category,
                  orElse: () => 'General Knowledge'),
              onChanged: (String? newValue) {
                setState(() {
                  category = categoryMap[newValue!]!;
                });
              },
              items: categoryMap.keys.map<DropdownMenuItem<String>>((String categoryName) {
                return DropdownMenuItem<String>(
                  value: categoryName,
                  child: Text(categoryName),
                );
              }).toList(),
            ),
            Text('Difficulty'),
            DropdownButton<String>(
              value: difficulty,
              onChanged: (String? newValue) {
                setState(() {
                  difficulty = newValue!;
                });
              },
              items: <String>['easy', 'medium', 'hard']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Text('Question Type'),
            DropdownButton<String>(
              value: questionType,
              onChanged: (String? newValue) {
                setState(() {
                  questionType = newValue!;
                });
              },
              items: <String>['multiple', 'boolean']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Pass data to the next screen (Quiz Screen)
                Navigator.pushNamed(context, '/quiz', arguments: {
                  'numberOfQuestions': numberOfQuestions,
                  'category': category,
                  'difficulty': difficulty,
                  'questionType': questionType
                });
              },
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
