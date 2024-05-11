import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kalahok_app/blocs/offline/category/local_category_bloc.dart';
import 'package:kalahok_app/data/models/offline/category.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/demo_screen.dart';
import 'package:kalahok_app/screens/error_screen.dart';
import 'package:kalahok_app/screens/online/category_screen.dart';
import 'package:kalahok_app/widgets/offline/local_category_widget.dart';
import 'package:kalahok_app/widgets/loading_overlay_widget.dart';

/// CHECKED
class LocalCategoryScreen extends StatefulWidget {
  final List<String> addresses;

  const LocalCategoryScreen({
    Key? key,
    required this.addresses,
  }) : super(key: key);

  @override
  State<LocalCategoryScreen> createState() => _LocalCategoryScreenState();
}

class _LocalCategoryScreenState extends State<LocalCategoryScreen> {
  bool isSwitched = false;
  var textValue = "You're in offline mode";

  void _toggleSwitch(bool value) {
    if(isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = "You're in Online Mode";
      });

      _switchToOnlineMode();
    } else {
      setState(() {
        isSwitched = false;
        textValue = "You're in Offline Mode";
      });
    }
  }

  void _switchToOnlineMode() {
    LoadingOverlayWidget.of(context).show();
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingOverlayWidget(
            progressText: "Please wait while downloading all the data, switching to Offline Mode",
            child: CategoryScreen(addresses: widget.addresses),
          ),
        ),
      );
      LoadingOverlayWidget.of(context).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return BlocProvider(
      create: (context) => LocalCategoryBloc()..add(GetLocalCategoryListEvent()),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 110,
          leading: Transform.translate(
            offset: const Offset(12, 0),
            child: Image.asset(AppConfig.logo),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(130),
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
              icon: Icon(
                Icons.info_outline,
                color: AppColor.subPrimary,
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
          ],
        ),
        body: BlocBuilder<LocalCategoryBloc, LocalCategoryState>(
          builder: (context, state) {
            if (state is LocalCategoryLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is LocalCategoryLoadedState) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 8),
                  _buildCategories(categories: state.categories),
                ],
              );
            }
            if (state is LocalCategoryErrorState) {
              /// todo:  fix this ui later
              return ErrorScreen(error: state.error);
            }
            return Container();
          }
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            Switch(
              onChanged: _toggleSwitch,
              value: isSwitched,
              activeColor: AppColor.primary,
              activeTrackColor: AppColor.warning,
              inactiveThumbColor: AppColor.secondary,
              inactiveTrackColor: AppColor.neutral,
            ),
            const SizedBox(width: 5),
            Text(
              textValue,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColor.neutral,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
          .map((category) => LocalCategoryWidget(
            category: category,
            addresses: widget.addresses,
          ),
        ).toList()
      ),
    );
  }
}
