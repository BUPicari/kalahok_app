import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalahok_app/blocs/survey/survey_bloc.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/category_screen.dart';
import 'package:kalahok_app/screens/current_location_map_screen.dart';
import 'package:kalahok_app/screens/review_screen.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class SurveyDoneScreen extends StatelessWidget {
  final Surveys survey;

  const SurveyDoneScreen({
    Key? key,
    required this.survey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyBloc()..add(SubmitSurveyResponseEvent(survey: survey)),
      child: BlocBuilder<SurveyBloc, SurveyState>(
        builder: (context, state) {
          if (state is SurveyForReviewState) {
            // return _buildForReview(context);
            return _buildDone(context);
          }
          if (state is SurveyDoneState) {
            return _buildDone(context);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildForReview(BuildContext context) {
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

  Widget _buildDone(BuildContext context) {
    final gformsSurveyUrl = Uri.parse('https://forms.gle/Lc97er4yWBDN6ipj6');

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
                child: Text(
                  'THANK YOU!',
                  style: TextStyle(
                    fontSize: 30,
                    color: AppColor.subPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                child: Text(
                  "You're part of the solution!",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColor.subPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                child: SvgPicture.asset(
                  'assets/images/survey-participants.svg',
                  semanticsLabel: 'Survey done',
                  height: 260,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: Text(
                  "You're 1 out of all the users who",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColor.subPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                child: Text(
                  "participated in this initiative",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColor.subPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        launchUrl(
                          gformsSurveyUrl,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(160, 40),
                        backgroundColor: AppColor.subPrimary,
                        foregroundColor: AppColor.subSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33),
                        ),
                      ),
                      icon: const Icon(Icons.comment),
                      label: Text(
                        "EVALUATE",
                        style: TextStyle(
                          color: AppColor.subSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CurrentLocationMapScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(160, 40),
                        backgroundColor: AppColor.subPrimary,
                        foregroundColor: AppColor.subSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33),
                        ),
                      ),
                      icon: const Icon(Icons.pin_drop),
                      label: Text(
                        "LOCATION",
                        style: TextStyle(
                          color: AppColor.subSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoryScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(160, 40),
                        backgroundColor: AppColor.subPrimary,
                        foregroundColor: AppColor.subSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33),
                        ),
                      ),
                      icon: const Icon(Icons.home),
                      label: Text(
                        'HOME',
                        style: TextStyle(
                          color: AppColor.subSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
