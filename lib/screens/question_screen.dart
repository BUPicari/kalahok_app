import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalahok_app/data/models/choice_model.dart';
import 'package:kalahok_app/data/models/question_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/category_screen.dart';
import 'package:kalahok_app/widgets/question_numbers_widget.dart';
import 'package:kalahok_app/widgets/questions_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  late PageController pageController;
  // late TextEditingController textController;
  late Question question;
  late List<Choice> selected;

  @override
  void initState() {
    super.initState();

    pageController = PageController();
    // textController = TextEditingController();
    question = widget.survey.questionnaires.first;
    selected = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      resizeToAvoidBottomInset: false,
      body: QuestionsWidget(
        survey: widget.survey,
        pageController: pageController,
        // textController: textController,
        onChangedPage: (index) => nextQuestion(index: index),
        onClickedChoice: selectChoice,
        onClickedRate: selectRate,
        onChanged: setTextFieldResponses,
        onAddOthers: setAddedOthers,
        onDateSelected: setDateSelected,
        onPressedPrev: setPrevQuestion,
        onPressedNext: setNextQuestion,
      ),
    );
  }

  PreferredSizeWidget buildAppBar(context) {
    return AppBar(
      title: Text(widget.survey.title),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColor.linearGradient,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      ),
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back,
          color: AppColor.subPrimary,
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const CategoryScreen(),
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
        // question.selectedChoices
        //     ?.map((choice) => question.selected?.add(choice.name));

        if (question.response == null) {
          setResponse(jsonEncode(choice.name));
        } else {
          // String? res = question.selected?.join(', ');
          // setResponse(res.toString());
          List<String> arrRes = question.response.toString().split(',');
          if (!arrRes.contains(jsonEncode(choice.name))) {
            setResponse("${question.response},${jsonEncode(choice.name)}");
          }
        }
      } else {
        question.selectedChoice = choice;
        setResponse(jsonEncode(choice.name));
      }
    });
  }

  void selectRate(int rate) {
    setState(() {
      question.selectedRate = rate.toInt();
      setResponse(jsonEncode((rate + 1).toString()));
    });
  }

  void setAddedOthers(String others) {
    setState(() {
      question.addedOthers = jsonEncode(others);
    });
  }

  void setTextFieldResponses(String response) {
    List<dynamic> textFieldResponse = <String>[];
    List<String> responses = response.toString().split(',');

    if (question.response != null) {
      textFieldResponse = jsonDecode(question.response.toString()) as List;
    }

    for (var i = 0; i <= int.parse(responses[0]); i++) {
      if (int.parse(responses[0]) == i) {
        if (textFieldResponse.asMap().containsKey(i)) {
          textFieldResponse[i] = responses[1].trim();
        } else {
          textFieldResponse.insert(i, responses[1].trim());
        }
      } else {
        if (!textFieldResponse.asMap().containsKey(i)) {
          textFieldResponse.insert(i, "");
        }
      }
    }

    setResponse(jsonEncode(textFieldResponse));
  }

  void setDateSelected(DateRangePickerSelectionChangedArgs args) {
    setResponse(jsonEncode(DateFormat('yyyy-MM-dd').format(args.value)));
  }

  void setResponse(String response) {
    setState(() {
      question.response = response;
    });
  }

  void setPrevQuestion(int index) {
    nextQuestion(
      index: index - 1,
      jump: true,
    );
  }

  void setNextQuestion(int index) {
    nextQuestion(
      index: index + 1,
      jump: true,
    );
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
      pageController.jumpToPage(indexPage);
    }
  }
}
