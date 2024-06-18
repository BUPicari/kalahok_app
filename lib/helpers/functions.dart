import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:kalahok_app/services/notification_service.dart';
import 'package:kalahok_app/data/models/offline/questionnaire_response.dart';
import 'package:kalahok_app/data/models/offline/survey_response.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/services/database_service.dart';

class Functions {
  /// Check if the array does not only contains empty string
  static bool arrDoesNotOnlyContainsEmptyString({
    required List<String> strArr,
  }) {
    int temp = 0;

    for (var item in strArr) {
      if (item.isNotEmpty) temp++;
    }

    return temp > 0;
  }

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

  /// Get audio filename in the file
  static String _getFilename({ required String path }) {
    List splitPath = path.split('/');
    return splitPath.last;
  }

  /// Get the recording path the directory
  static Future<String> getRecordingPath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final Directory appDirFolder = Directory('${documentsDirectory.path}/records');

    if (await appDirFolder.exists() == false) {
      await appDirFolder.create(recursive: true);
    }

    return appDirFolder.path;
  }

  /// Get audio recorded file
  static Future<String> _getAudioRecordedFile({
    required int questionId,
    required int surveyId,
  }) async {
    String timestamp = DateFormat.yMd().format(DateTime.now()).toString().replaceAll('/', '_');
    String appDirFolderPath = await getRecordingPath();
    final recordDir = Directory(appDirFolderPath);
    List recordFileLists = recordDir.listSync(recursive: true, followLinks: false);

    for (var dirFile in recordFileLists) {
      String filename = _getFilename(path: dirFile.path);
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

  /// Building the audio file widget
  static Future<Widget> buildAudioFileWidget({
    required int questionId,
    required int surveyId,
  }) async {
    String temp = await _getAudioRecordedFile(
      questionId: questionId,
      surveyId: surveyId,
    );

    String filename = temp != '' ? "recorded" : '';

    if (filename != '') {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(100, 40),
        ),
        icon: const Icon(Icons.music_note_rounded, size: 20),
        label: Text(
          filename,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        onPressed: null,
      );
    }

    return const Column();
  }

  /// Checking internet connection availability
  static Future<bool> get hasInternetConnection async {
    return await InternetConnectionChecker().hasConnection;
  }

  static void audioRename({ required String from, required String to }) async {
    String appDirFolderPath = await getRecordingPath();
    final recordDir = Directory(appDirFolderPath);
    List recordFileLists = recordDir.listSync(recursive: true, followLinks: false);

    for (var dirFile in recordFileLists) {
      String filename = _getFilename(path: dirFile.path);
      List temp = filename.split('@');
      List temp2 = temp.last.split('.');
      String status = temp2.first;
      String codec = temp2.last;

      if (status == from) {
        status = to;
        var path = dirFile.path;
        var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
        var newPath = path.substring(0, lastSeparator + 1) + '${temp.first}@$status.$codec';
        dirFile.rename(newPath);
      }
    }
  }

  /// From local db submit to api
  static void localToApi() async {
    final dbService = DatabaseService.dbService;
    final db = await dbService.database;

    /// Query db survey responses where is_sent = false
    List<Map<String, dynamic>> dbSurveyResponse = await db.query(
      'survey_response',
      columns: [
        'id',
        'survey_id',
        'detail_id',
        'is_sent',
      ],
      where: 'is_sent = ?',
      whereArgs: [0],
    );

    if (dbSurveyResponse.isNotEmpty) {
      List<SurveyResponse> surveyResponses = dbSurveyResponse.map((e) =>
        SurveyResponse.fromJson(e)).toList();

      for (var response in surveyResponses) {
        /// Query db questionnaires responses where survey response id
        List<Map<String, dynamic>> dbQuestionnaireResponse = await db.query(
          'questionnaire_response',
          columns: [
            'id',
            'survey_response_id',
            'question_id',
            'answer',
            'file',
          ],
          where: 'survey_response_id = ?',
          whereArgs: [response.id],
        );

        if (dbQuestionnaireResponse.isNotEmpty) {
          List<QuestionnaireResponse> questionnaireResponses = dbQuestionnaireResponse.map((e) =>
            QuestionnaireResponse.fromJson(e)).toList();

          var path = '/survey/responses';
          var url = Uri.parse(ApiConfig.baseUrl + path);

          /// Send is_sent = false questionnaire responses to api post request
          try {
            var request = http.MultipartRequest('POST', url);
            request.headers['X-Requested-With'] = "XMLHttpRequest";
            request.headers['x-api-key'] = ApiConfig.apiKey;

            request.fields['survey_id'] = response.surveyId.toString();
            request.fields['detailsId'] = response.detailId.toString();

            questionnaireResponses.asMap().forEach((index, value) async {
              request.fields['questionnaires[$index][questionnaire_id]'] =
                value.questionId.toString();
              request.fields['questionnaires[$index][answer]'] = value.answer;
              if (value.file != '') {
                request.files.add(await http.MultipartFile.fromPath(
                  'questionnaires[$index][files]-${value.questionId}',
                  value.file.toString(),
                ));
              }
            });

            await request.send();
            audioRename(from: 'LOCAL', to: 'DONE');

            /// Update the survey response to is_sent = true
            await db.update(
              'survey_response',
              { "is_sent": 1 },
              where: 'id = ?',
              whereArgs: [response.id],
              conflictAlgorithm: ConflictAlgorithm.replace,
            );

            /// Call the notification
            await NotificationService.showNotification(
              title: "Local to API responses submitted!",
              body: "All the unsent local responses are now submitted to the API server.",
              summary: "BosesKo Notification",
              notificationLayout: NotificationLayout.Inbox,
            );
          } catch (error) {
            print("Error: $error");
          }
        }
      }
    }
  }
}
