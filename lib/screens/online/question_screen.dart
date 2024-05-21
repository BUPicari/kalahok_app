import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/online/answer_model.dart';
import 'package:kalahok_app/data/models/online/questions_model.dart';
import 'package:kalahok_app/data/models/online/surveys_model.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/online/category_screen.dart';
import 'package:kalahok_app/widgets/loading_overlay_widget.dart';
import 'package:kalahok_app/widgets/online/question_numbers_widget.dart';
import 'package:kalahok_app/widgets/online/questions_widget.dart';

/// CHECKED
class QuestionScreen extends StatefulWidget {
  final Surveys survey;
  final List<String> addresses;

  const QuestionScreen({
    Key? key,
    required this.survey,
    required this.addresses,
  }) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late PageController pageController;
  late Questions question;

  @override
  void initState() {
    super.initState();

    pageController = PageController();
    question = widget.survey.questionnaires!.first;

    setState(() {
      question.surveyId = widget.survey.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return Scaffold(
      appBar: buildAppBar(context: context),
      resizeToAvoidBottomInset: false,
      body: QuestionsWidget(
        survey: widget.survey,
        pageController: pageController,
        onChangedPage: (index) => goTo(index: index),
        onSetResponse: (response) => setResponse(response: response),
        onPressedPrev: (index) => setPrevQuestion(index: index),
        onPressedNext: (index) => setNextQuestion(index: index),
        addresses: widget.addresses,
      ),
    );
  }

  PreferredSizeWidget buildAppBar({ required context }) {
    return AppBar(
      foregroundColor: AppColor.subPrimary,
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
          builder: (context) => LoadingOverlayWidget(
            progressText: AppConfig.offlineModeText,
            child: CategoryScreen(addresses: widget.addresses),
          ),
        )),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: QuestionNumbersWidget(
            questions: widget.survey.questionnaires!,
            question: question,
            onClickedNumber: (index) => goTo(
              index: index,
              jump: true,
            ),
          ),
        ),
      ),
    );
  }

  void setResponse({ required Answer response }) {
    setState(() {
      question.answer = response;
    });
  }

  void setPrevQuestion({ required int index }) {
    goTo(
      index: index - 1,
      jump: true,
    );
  }

  void setNextQuestion({ required int index }) {
    goTo(
      index: index + 1,
      jump: true,
    );
  }

  void goTo({ required int index, bool jump = false }) {
    final indexPage = index;

    setState(() {
      question = widget.survey.questionnaires![indexPage];
      question.surveyId = widget.survey.id;
    });

    if (jump) {
      pageController.jumpToPage(indexPage);
    }
  }
}
