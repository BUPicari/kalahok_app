import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/choice_model.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/screens/home_screen.dart';
import 'package:kalahok_app/widgets/question_numbers_widget.dart';
import 'package:kalahok_app/widgets/questions_widget.dart';

class QuestionScreen extends StatefulWidget {
  final Survey survey;

  const QuestionScreen({
    Key? key,
    required this.survey,
  }) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late PageController controller;
  late Question question;
  late List<Choice> selected;

  @override
  void initState() {
    super.initState();

    controller = PageController();
    question = widget.survey.questionnaires.first;
    selected = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: QuestionsWidget(
        survey: widget.survey,
        controller: controller,
        onChangedPage: (index) => nextQuestion(index: index),
        onClickedChoice: selectChoice,
        // onSelectChoices: selectMultipleChoices,
        onClickedRate: selectRate,
        onChanged: setResponse,
        onAddOthers: setAddedOthers,
      ),
    );
  }

  PreferredSizeWidget buildAppBar(context) {
    return AppBar(
      title: Text(widget.survey.title),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.indigo],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      ),
      leading: GestureDetector(
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        )),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: QuestionNumbersWidget(
            questions: widget.survey.questionnaires,
            question: question,
            onClickedNumber: (index) => nextQuestion(
              index: index,
              jump: true,
            ),
          ),
        ),
      ),
    );
  }

  void selectChoice(Choice choice) {
    setState(() {
      if (question.config.multipleAnswer) {
        if (selected.contains(choice)) {
          selected.remove(choice);
        } else {
          selected.add(choice);
        }
        question.selectedChoices = selected;

        if (question.response == null) {
          setResponse(choice.name);
        } else {
          setResponse("${question.response},${choice.name}");
        }
      } else {
        question.selectedChoice = choice;
        setResponse(choice.name);
      }
    });
  }

  void selectRate(int rate) {
    setState(() {
      question.selectedRate = rate.toInt();
      setResponse((rate + 1).toString());
    });
  }

  void setAddedOthers(String others) {
    setState(() {
      question.addedOthers = others;
    });
  }

  void setResponse(String response) {
    setState(() {
      question.response = response;
    });
  }

  void nextQuestion({
    required int index,
    bool jump = false,
  }) {
    final indexPage = index;

    setState(() {
      question = widget.survey.questionnaires[indexPage];
    });

    if (jump) {
      controller.jumpToPage(indexPage);
    }
  }
}
