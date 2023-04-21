import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  /// Height between every widget
  static List<Widget> heightBetween(
    List<Widget> children, {
    required double height,
  }) {
    if (children.isEmpty) return <Widget>[];
    if (children.length == 1) return children;

    final list = [children.first, SizedBox(height: height)];
    for (int i = 1; i < children.length - 1; i++) {
      final child = children[i];
      list.add(child);
      list.add(SizedBox(height: height));
    }
    list.add(children.last);

    return list;
  }

  /// Checking internet connection availability
  static Future<bool> get hasInternetConnection async {
    return await InternetConnectionChecker().hasConnection;
  }

  /// Get review responses/answers
  static Widget getReviewResponse({required Questions question}) {
    List<String> answer = question.answer?.answers ?? [];
    String otherAnswer = question.answer?.otherAnswer ?? '';
    if (question.config.multipleAnswer ||
        question.config.canAddOthers ||
        question.type == 'openEnded' ||
        question.type == 'dropdown') {
      List<Widget> responsesWidget = answer.map((res) {
        String ans = answer.length == 1 && res.isNotEmpty
          ? 'Answer: $res'
          : res.isNotEmpty
            ? 'Answer (${answer.indexOf(res) + 1}):  $res'
            : '';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              ans,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ),
        ]);
      }).toList();

      Widget addOthersWidget = Column();
      String othersOrSpecifyText = question.type == 'trueOrFalse'
        ? 'Specify:'
        : 'Others:';

      if (otherAnswer.isNotEmpty) {
        addOthersWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              '$othersOrSpecifyText $otherAnswer',
              style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 16),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: responsesWidget,
          ),
          addOthersWidget,
        ],
      );
    }

    return Text(
        answer.isNotEmpty ? 'Answer: ${answer.join(', ')}' : '',
        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
    );
  }

  static bool doesNotOnlyContainsEmptyString({required List<String> strArr}) {
    int temp = 0;

    for (var item in strArr) {
      if (item.isNotEmpty) {
        temp++;
      }
    }

    return temp > 0 ? true : false;
  }

  /// Update questionnaires num of required items
  static void updateQuestionnaireRequiredNum({
    required Surveys survey,
    required Questions question,
  }) {
    int numOfRequired = survey.numOfRequired ?? 0;
    question.config.isRequired
        ? survey.numOfRequired = numOfRequired + 1
        : null;
  }


  /// Get question response
  /// for type [OpenEnded, Dropdown, Ratings, DatePicker]
  ///   @return answer: List<String>
  /// for type [MultipleChoice, TrueOrFalse]
  ///   @return answer: {selected: List<String>, others: String}
  static String getQuestionResponse({required Questions question}) {
    String otherAnswer = question.answer?.otherAnswer ?? '';
    List<String> answer = question.answer?.answers ?? [];

    if (question.config.canAddOthers) {
      return jsonEncode({
        'selected': answer,
        'others': otherAnswer,
      });
    }

    return json.encode(answer);
  }

  static Future<String> getRecordingPath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final Directory appDirFolder = Directory('${documentsDirectory.path}/records');
    if (await appDirFolder.exists() == false) {
      await appDirFolder.create(recursive: true);
    }

    return appDirFolder.path;
  }

  static String getFilename({required String path}) {
    List splitPath = path.split('/');
    return splitPath.last;
  }

  static void renameFile({required File file, required String newFileName}) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    file.rename(newPath);
  }

  /// PENDING - kakarecord plng and di pa na balik sa waiver
  /// DENY - lahat ng record na PENDING before tas di na submit
  /// SUBMITTED - lahat ng record na PENDING before ang na save sa sqlite or na submit
  /// DONE - lahat ng record na from SUBMITTED to post requested to api
  static void audioRename({required String from, required String to}) async {
    String appDirFolderPath = await getRecordingPath();
    final recordDir = Directory(appDirFolderPath);
    List recordFileLists = recordDir.listSync(recursive: true, followLinks: false);

    for (var dirFile in recordFileLists) {
      String filename = getFilename(path: dirFile.path);
      List temp = filename.split('@');
      List temp2 = temp.last.split('.');
      String status = temp2.first;
      String codec = temp2.last;
      if (status == from) {
        status = to;
        renameFile(file: dirFile, newFileName: '${temp.first}@$status.$codec');
      }
    }
  }
}
