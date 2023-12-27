import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalahok_app/blocs/category/category_bloc.dart';
import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/error_screen.dart';
import 'package:kalahok_app/screens/category_screen.dart';
import 'package:kalahok_app/widgets/category_survey_widget.dart';

class CategorySurveyScreen extends StatelessWidget {
  final Category category;

  const CategorySurveyScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBloc()
        ..add(GetCategoryWithSurveyListEvent(categoryId: category.id)),
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: AppColor.subPrimary,
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CategoryScreen(),
            )),
          ),
          title: Text(category.name),
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
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryWithSurveyLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CategoryWithSurveyLoadedState) {
              if (state.categoryWithSurvey?.name == "none") {
                return const ErrorScreen(
                  error: "No Active Survey as of the moment!",
                );
              }

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCategorySurveys(categoryWithSurvey: state.categoryWithSurvey),
                ],
              );
            }
            if (state is CategoryErrorState) {
              // fix this ui later
              return ErrorScreen(error: state.error);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active',
          style: TextStyle(fontSize: 16, color: AppColor.subPrimary),
        ),
        Text(
          'Surveys',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.subPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySurveys({Category? categoryWithSurvey}) {
    return SizedBox(
      height: 600,
      child: GridView(
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: categoryWithSurvey!.surveys!
          .map((survey) => CategorySurveyWidget(category: category, survey: survey))
          .toList(),
      ),
    );
  }
}
