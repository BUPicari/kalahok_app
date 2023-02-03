import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalahok_app/blocs/survey/survey_bloc.dart';
import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/data/models/survey_model.dart';
import 'package:kalahok_app/screens/question_screen.dart';
import 'package:kalahok_app/screens/error_screen.dart';

class SurveyScreen extends StatelessWidget {
  final Category category;

  const SurveyScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SurveyBloc()..add(GetSurveyListEvent(categoryId: category.id)),
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
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              child: Column(children: [
                const SizedBox(height: 45),
                const Text(
                  ' Hi, Welcome to',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  survey.title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Read each questions thoroughly, submit once done with the survey.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ]),
            ),
          ),
          Expanded(
            flex: 5,
            child: Stack(children: [
              Positioned(
                child: Image.asset(
                  'assets/images/survey-welcome.png',
                  height: 280,
                ),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuestionScreen(survey: survey),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'GET STARTED',
                            style: TextStyle(
                              color: Colors.white,
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
        ]),
      ),
    );
  }
}
