import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/data/models/surveys_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/record_screen.dart';
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
  static Widget getReviewResponse({
    required context,
    required Questions question
  }) {
    List<String> answer = question.answer?.answers ?? [];
    String otherAnswer = question.answer?.otherAnswer ?? '';
    String file = question.answer?.file ?? '';
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

      if (question.type == 'openEnded' && file.isNotEmpty) {
        List<Widget> tempResponsesWidget = responsesWidget;
        responsesWidget = [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tempResponsesWidget,
          ),
          const SizedBox(height: 5),
          const Text(
            'Recorded File:',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 50),
                backgroundColor: AppColor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(33),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecordScreen(question: question),
                  ),
                );
              },
              label: Text(
                // getFilename(path: file),
                'Play Recorded File',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColor.subPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ];
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

    if ((!question.config.multipleAnswer && !question.config.canAddOthers &&
        question.type != "openEnded" && question.type != "dropdown") ||
      (question.type == "openEnded" && answer.length == 1) ||
      (question.type == "dropdown" && answer.length == 1) ||
      (question.config.multipleAnswer && !question.config.canAddOthers &&
        answer.length == 1)) {
      return answer[0];
    }

    if (question.config.canAddOthers) {
      if (otherAnswer == '' && answer.length == 1) {
        return answer[0];
      }

      if (otherAnswer != '' && answer.length == 1) {
        return jsonEncode({
          'selected': answer[0],
          'others': otherAnswer,
        });
      }

      if (otherAnswer == '' && answer.length > 1) {
        return json.encode(answer);
      }

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

  static String getNewPath({
    required String oldPath,
    required String from,
    required String to
  }) {
    List splitPath = oldPath.split('recording');
    List temp = splitPath.last.split('@');
    List temp2 = temp.last.split('.');
    String status = temp2.first;
    String codec = temp2.last;
    if (status == from) {
      status = to;
      return '${splitPath.first}recording${temp.first}@$status.$codec';
    }

    return oldPath;
  }

  static Future<String> getAudioRecordedFile({
    required int questionId,
    required int surveyId
  }) async {
    String timestamp = DateFormat.yMd().format(DateTime.now()).toString().replaceAll('/', '_');
    String appDirFolderPath = await getRecordingPath();
    final recordDir = Directory(appDirFolderPath);
    List recordFileLists = recordDir.listSync(recursive: true, followLinks: false);

    for (var dirFile in recordFileLists) {
      String filename = getFilename(path: dirFile.path);
      List splitted = filename.split('-');
      if (splitted[1] == timestamp) {
        List questionSplit = splitted[2].split('#');
        List surveySplit = splitted[3].split('#');
        List statusSplit = filename.split('@');
        if (
          statusSplit.last.split('.').first == 'PENDING' &&
          questionSplit.last == questionId.toString() &&
          surveySplit.last.split('@').first == surveyId.toString()
        ) {
          return filename;
        }
      }
    }

    return '';
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
