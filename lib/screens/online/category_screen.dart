import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kalahok_app/blocs/online/category/category_bloc.dart';
import 'package:kalahok_app/data/models/online/category_model.dart';
import 'package:kalahok_app/data/resources/offline/api_to_db_repo.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/demo_screen.dart';
import 'package:kalahok_app/screens/error_screen.dart';
import 'package:kalahok_app/screens/offline/local_category_screen.dart';
import 'package:kalahok_app/widgets/online/category_widget.dart';
import 'package:kalahok_app/widgets/loading_overlay_widget.dart';

/// CHECKED
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({ Key? key }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiToDbRepository _apiToDbRepository = ApiToDbRepository();

  void _offlineMode() async {
    LoadingOverlay.of(context).show();
    await _apiToDbRepository.insertAllDataFromApiToLocalDB();
    await Future.delayed(const Duration(seconds: 60));
    LoadingOverlay.of(context).hide();

    Future.delayed(const Duration(seconds: 10), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingOverlay(
            progressText: "ONLINE MODE",
            child: const LocalCategoryScreen(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return BlocProvider(
      create: (context) => CategoryBloc()..add(GetCategoryListEvent()),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 110,
          leading: Transform.translate(
            offset: const Offset(12, 0),
            child: Image.asset(AppConfig.logoPreview),
          ),
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              tooltip: "Toolkit Demo",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DemoScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.offline_bolt_outlined,
                color: Colors.white,
              ),
              tooltip: "Offline Mode",
              onPressed: _offlineMode,
            )
          ],
        ),
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CategoryLoadedState) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 8),
                  _buildCategories(categories: state.categories),
                ],
              );
            }
            if (state is CategoryErrorState) {
              /// todo: fix this ui later
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
          'Hello please',
          style: TextStyle(fontSize: 16, color: AppColor.subPrimary),
        ),
        Text(
          'Choose a domain',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.subPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories({ required List<Category> categories }) {
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
        children: categories
          .map((category) => CategoryWidget(category: category))
          .toList(),
      ),
    );
  }
}
