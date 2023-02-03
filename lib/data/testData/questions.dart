import 'package:kalahok_app/data/models/choice_model.dart';
import 'package:kalahok_app/data/models/config_model.dart';
import 'package:kalahok_app/data/models/rate_model.dart';
import 'package:kalahok_app/data/models/question_model.dart';

final unifastQuestions = [
  Question(
    id: 1,
    question: 'Question 1 Unifast?',
    type: 'multipleChoice',
    choices: [
      Choice(name: 'Choice 1'),
      Choice(name: 'Choice 2'),
      Choice(name: 'Choice 3'),
      Choice(name: 'Choice 4'),
    ],
    config: Config(
      multipleAnswer: false,
      canAddOthers: false,
      useYesOrNo: false,
    ),
    rates: [],
    addedAt: '',
    updatedAt: '',
  ),
  Question(
    id: 2,
    question: 'Question 2 Unifast?',
    type: 'openEnded',
    choices: [],
    config: Config(
      multipleAnswer: false,
      canAddOthers: false,
      useYesOrNo: false,
    ),
    rates: [],
    addedAt: '',
    updatedAt: '',
  ),
  Question(
    id: 3,
    question: 'Question 3 Unifast?',
    type: 'trueOrFalse',
    choices: [
      Choice(name: 'True'),
      Choice(name: 'False'),
    ],
    config: Config(
      multipleAnswer: false,
      canAddOthers: false,
      useYesOrNo: false,
    ),
    rates: [],
    addedAt: '',
    updatedAt: '',
  ),
  Question(
    id: 4,
    question: 'Question 4 Unifast?',
    type: 'rating',
    choices: [],
    config: Config(
      multipleAnswer: false,
      canAddOthers: false,
      useYesOrNo: false,
    ),
    rates: [Rate(min: '1', max: '10')],
    addedAt: '',
    updatedAt: '',
  ),
];

final drrmoQuestions = [
  Question(
    id: 1,
    question: 'Question 1 DRRMO?',
    type: 'multipleChoice',
    choices: [
      Choice(name: 'Choice 1'),
      Choice(name: 'Choice 2'),
      Choice(name: 'Choice 3'),
      Choice(name: 'Choice 4'),
    ],
    config: Config(
      multipleAnswer: false,
      canAddOthers: false,
      useYesOrNo: false,
    ),
    rates: [],
    addedAt: '',
    updatedAt: '',
  ),
  Question(
    id: 2,
    question: 'Question 2 DRRMO?',
    type: 'openEnded',
    choices: [],
    config: Config(
      multipleAnswer: false,
      canAddOthers: false,
      useYesOrNo: false,
    ),
    rates: [],
    addedAt: '',
    updatedAt: '',
  ),
  Question(
    id: 3,
    question: 'Question 3 DRRMO?',
    type: 'trueOrFalse',
    choices: [
      Choice(name: 'True'),
      Choice(name: 'False'),
    ],
    config: Config(
      multipleAnswer: false,
      canAddOthers: false,
      useYesOrNo: false,
    ),
    rates: [],
    addedAt: '',
    updatedAt: '',
  ),
  Question(
    id: 4,
    question: 'Question 4 DRRMO?',
    type: 'rating',
    choices: [],
    config: Config(
      multipleAnswer: false,
      canAddOthers: false,
      useYesOrNo: false,
    ),
    rates: [Rate(min: '1', max: '5')],
    addedAt: '',
    updatedAt: '',
  ),
];

// final questions = [
//   Question(
//     text: 'Which planet is the hottest in the solar system?',
//     options: [
//       const Option(code: 'A', text: 'Earth', isCorrect: false),
//       const Option(code: 'B', text: 'Venus', isCorrect: true),
//       const Option(code: 'C', text: 'Jupiter', isCorrect: false),
//       const Option(code: 'D', text: 'Saturn', isCorrect: false),
//     ],
//     solution: 'Venus is the hottest planet in the solar system',
//   ),
//   Question(
//     text: 'How many molecules of oxygen does ozone have?',
//     options: [
//       const Option(code: 'A', text: '1', isCorrect: false),
//       const Option(code: 'B', text: '2', isCorrect: false),
//       const Option(code: 'C', text: '5', isCorrect: false),
//       const Option(code: 'D', text: '3', isCorrect: true),
//     ],
//     solution: 'Ozone have 3 molecules of oxygen',
//   ),
//   Question(
//     text: 'What is the symbol for potassium?',
//     options: [
//       const Option(code: 'A', text: 'N', isCorrect: false),
//       const Option(code: 'B', text: 'S', isCorrect: false),
//       const Option(code: 'C', text: 'P', isCorrect: false),
//       const Option(code: 'D', text: 'K', isCorrect: true),
//     ],
//     solution: 'The symbol for potassium is K',
//   ),
//   Question(
//     text:
//         'Which of these plays was famously first performed posthumously after the playwright committed suicide?',
//     options: [
//       const Option(code: 'A', text: '4.48 Psychosis', isCorrect: true),
//       const Option(code: 'B', text: 'Hamilton', isCorrect: false),
//       const Option(code: 'C', text: "Much Ado About Nothing", isCorrect: false),
//       const Option(code: 'D', text: "The Birthday Party", isCorrect: false),
//     ],
//     solution: '4.48 Psychosis is the correct answer for this question',
//   ),
//   Question(
//     text: 'What year was the very first model of the iPhone released?',
//     options: [
//       const Option(code: 'A', text: '2005', isCorrect: false),
//       const Option(code: 'B', text: '2008', isCorrect: false),
//       const Option(code: 'C', text: '2007', isCorrect: true),
//       const Option(code: 'D', text: '2006', isCorrect: false),
//     ],
//     solution: 'iPhone was first released in 2007',
//   ),
//   Question(
//     text: ' Which element is said to keep bones strong?',
//     options: [
//       const Option(code: 'A', text: 'Carbon', isCorrect: false),
//       const Option(code: 'B', text: 'Oxygen', isCorrect: false),
//       const Option(code: 'C', text: 'Calcium', isCorrect: true),
//       const Option(
//         code: 'D',
//         text: 'Pottasium',
//         isCorrect: false,
//       ),
//     ],
//     solution: 'Calcium is the element responsible for keeping the bones strong',
//   ),
//   Question(
//     text: 'What country won the very first FIFA World Cup in 1930?',
//     options: [
//       const Option(code: 'A', text: 'Brazil', isCorrect: false),
//       const Option(code: 'B', text: 'Germany', isCorrect: false),
//       const Option(code: 'C', text: 'Italy', isCorrect: false),
//       const Option(code: 'D', text: 'Uruguay', isCorrect: true),
//     ],
//     solution: 'Uruguay was the first country to win world cup',
//   ),
//   Question(
//     text: 'What country won the very first FIFA World Cup in 1930?',
//     options: [
//       const Option(code: 'A', text: 'Brazil', isCorrect: false),
//       const Option(code: 'B', text: 'Germany', isCorrect: false),
//       const Option(code: 'C', text: 'Italy', isCorrect: false),
//       const Option(code: 'D', text: 'Uruguay', isCorrect: true),
//     ],
//     solution: 'Uruguay was the first country to win world cup',
//   ),
//   Question(
//     text: 'What country won the very first FIFA World Cup in 1930?',
//     options: [
//       const Option(code: 'A', text: 'Brazil', isCorrect: false),
//       const Option(code: 'B', text: 'Germany', isCorrect: false),
//       const Option(code: 'C', text: 'Italy', isCorrect: false),
//       const Option(code: 'D', text: 'Uruguay', isCorrect: true),
//     ],
//     solution: 'Uruguay was the first country to win world cup',
//   ),
// ];
