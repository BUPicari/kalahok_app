import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalahok_app/blocs/survey/survey_bloc.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/screens/home_screen.dart';

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
          return buildDone(context);
        },
      ),
    );
  }

  Widget buildDone(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Colors.indigo],
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
              const SizedBox(
                child: Text(
                  "You're all set!",
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
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
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'BACK TO HOME',
                            style: TextStyle(
                              color: Colors.black,
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
