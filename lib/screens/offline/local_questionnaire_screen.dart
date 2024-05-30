import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

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
  final List<String> addresses;
  final int? index;

  const LocalQuestionnaireScreen({
    Key? key,
    required this.survey,
    required this.questionnaires,
    required this.addresses,
    this.index,
  }) : super(key: key);

  @override
  State<LocalQuestionnaireScreen> createState() => _LocalQuestionnaireScreenState();
}

class _LocalQuestionnaireScreenState extends State<LocalQuestionnaireScreen> {
  late PageController pageController;
  late Questionnaire questionnaire;
  late ScrollController scrollController;
  late ListObserverController observerController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: widget.index ?? 0);
    questionnaire = widget.questionnaires[widget.index ?? 0];
    scrollController = ScrollController();
    observerController = ListObserverController(controller: scrollController);
  }

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return Scaffold(
      appBar: _buildAppBar(context: context),
      body: LocalQuestionnaireWidget(
        questionnaires: widget.questionnaires,
        pageController: pageController,
        onChangedPage: (index) => _goTo(index: index),
        onSetResponse: (response) => _setResponse(response: response),
        onPressedPrev: (index) => _setPrevQuestion(index: index),
        onPressedNext: (index) => _setNextQuestion(index: index),
        addresses: widget.addresses,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({ required context }) {
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
            progressText: AppConfig.onlineModeText,
            child: LocalCategoryScreen(addresses: widget.addresses),
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
            scrollController: scrollController,
            observerController: observerController,
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
      scrollTo(i: index);
    }
  }

  void scrollTo({ required int i }) {
    observerController.animateTo(
      index: i,
      duration: const Duration(seconds: 1),
      curve: Curves.ease,
    );
  }
}
