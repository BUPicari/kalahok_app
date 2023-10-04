import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalahok_app/blocs/survey/survey_bloc.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/error_screen.dart';
import 'package:kalahok_app/screens/question_screen.dart';

class WaiverScreen extends StatelessWidget {
  final Surveys survey;

  const WaiverScreen({
    Key? key,
    required this.survey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyBloc()..add(GetSurveyWithQuestionnairesEvent(surveyId: survey.id)),
      child: Scaffold(
        body: BlocBuilder<SurveyBloc, SurveyState>(
          builder: (context, state) {
            if (state is SurveyLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SurveyLoadedState) {
              if (state.surveyWithQuestionnaires?.title == "none") {
                return const ErrorScreen(
                  error: "Unable to Take the Survey!",
                );
              }

              return _buildContent(context: context, surveyWithQuestionnaires: state.surveyWithQuestionnaires);
            }
            if (state is SurveyErrorState) {
              // fix this ui later
              return ErrorScreen(error: state.error);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildContent({context, Surveys? surveyWithQuestionnaires}) {
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
                      surveyWithQuestionnaires?.waiver ?? "",
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
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(survey: surveyWithQuestionnaires!),
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
                          'PROCEED',
                          style: TextStyle(
                            color: AppColor.subSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
