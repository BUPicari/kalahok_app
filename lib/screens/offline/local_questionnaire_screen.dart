import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/response.dart';
import 'package:kalahok_app/data/models/offline/survey.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/offline/local_category_screen.dart';
import 'package:kalahok_app/widgets/loading_overlay_widget.dart';
import 'package:kalahok_app/widgets/offline/local_questionnaire_orders_widget.dart';
import 'package:kalahok_app/widgets/offline/local_questionnaire_widget.dart';

/// CHECKED
class LocalQuestionnaireScreen extends StatefulWidget {
  final Survey survey;
  final List<Questionnaire> questionnaires;

  const LocalQuestionnaireScreen({
    Key? key,
    required this.survey,
    required this.questionnaires,
  }) : super(key: key);

  @override
  State<LocalQuestionnaireScreen> createState() => _LocalQuestionnaireScreenState();
}

class _LocalQuestionnaireScreenState extends State<LocalQuestionnaireScreen> {
  late PageController pageController;
  late Questionnaire questionnaire;

  @override
  void initState() {
    super.initState();

    pageController = PageController();
    questionnaire = widget.questionnaires.first;
  }

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return Scaffold(
      appBar: _buildAppBar(context: context),
      resizeToAvoidBottomInset: false,
      body: LocalQuestionnaireWidget(
        questionnaires: widget.questionnaires,
        pageController: pageController,
        onChangedPage: (index) => _goTo(index: index),
        onSetResponse: (response) => _setResponse(response: response),
        onPressedPrev: (index) => _setPrevQuestion(index: index),
        onPressedNext: (index) => _setNextQuestion(index: index),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({ required context }) {
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
          builder: (context) => LoadingOverlay(
            progressText: "ONLINE MODE",
            child: const LocalCategoryScreen(),
          ),
        )),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: LocalQuestionnaireOrdersWidget(
            questionnaires: widget.questionnaires,
            questionnaire: questionnaire,
            onClickedNumber: (index) => _goTo(
              index: index,
              jump: true,
            ),
          ),
        ),
      ),
    );
  }

  void _setResponse({ required Response response }) {
    setState(() {
      questionnaire.response = response;
    });
  }

  void _setPrevQuestion({ required int index }) {
    _goTo(
      index: index - 1,
      jump: true,
    );
  }

  void _setNextQuestion({ required int index }) {
    _goTo(
      index: index + 1,
      jump: true,
    );
  }

  void _goTo({ required int index, bool jump = false }) {
    final indexPage = index;

    setState(() {
      questionnaire = widget.questionnaires[indexPage];
    });

    if (jump) {
      pageController.jumpToPage(indexPage);
    }
  }
}
