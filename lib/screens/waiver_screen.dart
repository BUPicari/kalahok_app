import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalahok_app/blocs/survey/survey_bloc.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/error_screen.dart';
import 'package:kalahok_app/screens/question_screen.dart';

class WaiverScreen extends StatelessWidget {
  final Surveys surveys;

  const WaiverScreen({
    Key? key,
    required this.surveys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SurveyBloc()..add(GetSurveyListEvent(surveyId: surveys.id)),
      child: Scaffold(
        body: BlocBuilder<SurveyBloc, SurveyState>(
          builder: (context, state) {
            if (state is SurveyLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is SurveyLoadedState) {
              return _buildContent(context: context, survey: state.survey);
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

  Widget _buildContent({context, required Survey survey}) {
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
                      surveys.waiver,
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
          ],
        ),
      ),
    );
  }
}
