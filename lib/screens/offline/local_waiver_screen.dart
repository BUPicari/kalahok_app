import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kalahok_app/blocs/offline/questionnaire/local_questionnaire_bloc.dart';
import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/survey_detail.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/error_screen.dart';
import 'package:kalahok_app/screens/offline/local_category_screen.dart';
import 'package:kalahok_app/screens/offline/local_questionnaire_screen.dart';
import 'package:kalahok_app/widgets/loading_overlay_widget.dart';

/// CHECKED
class LocalWaiverScreen extends StatefulWidget {
  final SurveyDetail surveyDetail;
  final List<String> addresses;

  const LocalWaiverScreen({
    Key? key,
    required this.surveyDetail,
    required this.addresses,
  }) : super(key: key);

  @override
  State<LocalWaiverScreen> createState() => _LocalWaiverScreenState();
}

class _LocalWaiverScreenState extends State<LocalWaiverScreen> {
  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return BlocProvider(
      create: (context) => LocalQuestionnaireBloc()..add(GetLocalQuestionnaireByDetailListEvent(
        surveyId: widget.surveyDetail.survey.id,
        detailsId: widget.surveyDetail.id,
      )),
      child: Scaffold(
        body: BlocBuilder<LocalQuestionnaireBloc, LocalQuestionnaireState>(
          builder: (context, state) {
            if (state is LocalQuestionnaireByDetailLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is LocalQuestionnaireByDetailLoadedState) {
              return _buildContent(
                context: context,
                questionnaires: state.questionnaires,
              );
            }
            if (state is LocalQuestionnaireErrorState) {
              /// todo: fix this ui later
              return ErrorScreen(error: state.error);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildContent({
    context,
    required List<Questionnaire> questionnaires,
  }) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColor.linearGradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 50),
                  SizedBox(
                    child: SvgPicture.asset(
                      'assets/images/survey-waiver.svg',
                      semanticsLabel: 'Survey Waiver',
                      height: 260,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    child: Text(
                      'WAIVER',
                      style: TextStyle(
                        fontSize: 30,
                        color: AppColor.subPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    child: Text(
                      questionnaires[0].survey.waiver,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColor.subPrimary,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 30),
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingOverlayWidget(
                            progressText: AppConfig.onlineModeText,
                            child: LocalCategoryScreen(addresses: widget.addresses),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.subPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(33),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Back',
                          style: TextStyle(
                            color: AppColor.subSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocalQuestionnaireScreen(
                            survey: widget.surveyDetail.survey,
                            questionnaires: questionnaires,
                            addresses: widget.addresses,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.subPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(33),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Proceed',
                          style: TextStyle(
                            color: AppColor.subSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
