import 'dart:math';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kalahok_app/data/models/category_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/category_survey_screen.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CategorySurveyScreen(category: category),
      )),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<bool>(
              future: InternetConnectionChecker().hasConnection,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Column();
                  } else {
                    if (snapshot.data == true) {
                      return Image.network(
                        ApiConfig.baseUrl + category.image,
                        width: 70,
                      );
                    } else {
                      return Column();
                    }
                  }
                } else {
                  return Column();
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              style: TextStyle(
                color: AppColor.subPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
