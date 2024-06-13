import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kalahok_app/blocs/offline/survey/local_survey_bloc.dart';
import 'package:kalahok_app/data/models/offline/survey.dart';
import 'package:kalahok_app/data/models/offline/category.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/error_screen.dart';
import 'package:kalahok_app/screens/offline/local_category_screen.dart';
import 'package:kalahok_app/widgets/offline/local_survey_widget.dart';
import 'package:kalahok_app/widgets/loading_overlay_widget.dart';

class LocalSurveyScreen extends StatefulWidget {
  final Category category;
  final List<String> addresses;

  const LocalSurveyScreen({
    Key? key,
    required this.category,
    required this.addresses,
  }) : super(key: key);

  @override
  State<LocalSurveyScreen> createState() => _LocalSurveyScreenState();
}

class _LocalSurveyScreenState extends State<LocalSurveyScreen> {
  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return BlocProvider(
      create: (context) => LocalSurveyBloc()
        ..add(GetLocalSurveyByCategoryListEvent(categoryId: widget.category.id)),
      child: Scaffold(
        appBar: AppBar(
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
          foregroundColor: AppColor.subPrimary,
          title: Text(widget.category.name),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: _buildWelcome(),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColor.linearGradient,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<LocalSurveyBloc, LocalSurveyState>(
            builder: (context, state) {
              if (state is LocalSurveyByCategoryLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is LocalSurveyByCategoryLoadedState) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  children: [
                    _buildSurveys(surveys: state.surveys),
                  ],
                );
              }
              if (state is LocalSurveyErrorState) {
                return ErrorScreen(error: state.error);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tap below your selected',
          style: TextStyle(fontSize: 16, color: AppColor.subPrimary),
        ),
        Text(
          'Active Surveys',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.subPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSurveys({ required List<Survey> surveys }) {
    return SizedBox(
      height: 200,
      child: GridView(
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        children: surveys
          .map((survey) => LocalSurveyWidget(
            survey: survey,
            addresses: widget.addresses,
          )).toList()
      ),
    );
  }
}
