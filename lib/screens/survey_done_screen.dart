import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalahok_app/blocs/survey/survey_bloc.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/home_screen.dart';
import 'package:kalahok_app/screens/review_screen.dart';

class SurveyDoneScreen extends StatelessWidget {
  final Survey survey;

  const SurveyDoneScreen({
    Key? key,
    required this.survey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SurveyBloc()..add(SubmitSurveyResponseEvent(survey: survey)),
      child: BlocBuilder<SurveyBloc, SurveyState>(
        builder: (context, state) {
          if (state is SurveyForReviewState) {
            return buildForReview(context);
          }
          if (state is SurveyDoneState) {
            return buildDone(context);
          }
          return Container();
        },
      ),
    );
  }

  Widget buildForReview(BuildContext context) {
    return Scaffold(
      body: Container(
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
              const SizedBox(height: 100),
              SizedBox(
                child: SvgPicture.asset(
                  'assets/images/survey-required.svg',
                  semanticsLabel: 'Survey required',
                  height: 260,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                child: Text(
                  "Please answer all the",
                  style: TextStyle(
                    fontSize: 23,
                    color: AppColor.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                child: Text(
                  "required questions!",
                  style: TextStyle(
                    fontSize: 23,
                    color: AppColor.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 140),
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
                            builder: (context) => ReviewScreen(survey: survey),
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
                            'BACK TO REVIEW',
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
      ),
    );
  }

  Widget buildDone(BuildContext context) {
    return Scaffold(
      body: Container(
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
              const SizedBox(height: 100),
              SizedBox(
                child: Image.asset(
                  'assets/images/survey-done.png',
                  height: 280,
                ),
              ),
              const SizedBox(height: 45),
              SizedBox(
                child: Text(
                  "You're all set!",
                  style: TextStyle(
                    fontSize: 23,
                    color: AppColor.subPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 140),
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
                            builder: (context) => const HomeScreen(),
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
                            'BACK TO HOME',
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
      ),
    );
  }
}
