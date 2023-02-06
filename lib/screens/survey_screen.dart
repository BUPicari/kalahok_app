import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalahok_app/blocs/survey/survey_bloc.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/question_screen.dart';
import 'package:kalahok_app/screens/error_screen.dart';

class SurveyScreen extends StatelessWidget {
  final Surveys survey;

  const SurveyScreen({
    Key? key,
    required this.survey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SurveyBloc()..add(GetSurveyListEvent(surveyId: survey.id)),
      child: Scaffold(
        body: BlocBuilder<SurveyBloc, SurveyState>(
          builder: (context, state) {
            if (state is SurveyLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SurveyLoadedState) {
              return buildContent(context: context, survey: state.survey);
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

  Widget buildContent({context, required Survey survey}) {
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Column(children: [
              const SizedBox(height: 45),
              Text(
                ' Hi, Welcome to',
                style: TextStyle(
                  fontSize: 23,
                  color: AppColor.subPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                survey.title,
                style: TextStyle(
                  fontSize: 20,
                  color: AppColor.warning,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Read each questions thoroughly, submit once done with the survey.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.subPrimary,
                ),
              ),
            ]),
          ),
          SizedBox(
            child: Image.asset(
              'assets/images/survey-welcome.png',
              height: 280,
            ),
          ),
          const SizedBox(height: 80),
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
                        builder: (context) => QuestionScreen(survey: survey),
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
        ]),
      ),
    );
  }
}
