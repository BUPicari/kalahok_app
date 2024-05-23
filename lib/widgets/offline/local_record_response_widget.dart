import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/survey.dart';
import 'package:kalahok_app/helpers/functions.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/offline/local_record_screen.dart';

/// CHECKED
class LocalRecordResponseWidget extends StatefulWidget {
  final Questionnaire questionnaire;
  final List<Questionnaire> questionnaires;
  final Survey survey;
  final List<String> addresses;
  final int index;

  const LocalRecordResponseWidget({
    Key? key,
    required this.questionnaire,
    required this.questionnaires,
    required this.survey,
    required this.addresses,
    required this.index,
  }) : super(key: key);

  @override
  State<LocalRecordResponseWidget> createState() => _LocalRecordResponseWidgetState();
}

class _LocalRecordResponseWidgetState extends State<LocalRecordResponseWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Functions.buildAudioFileWidget(
        questionId: widget.questionnaire.id,
        surveyId: widget.questionnaire.survey.id,
      ),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              _recordBtn(context),
              const SizedBox(width: 10),
              snapshot.data,
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      }
    );
  }

  Widget _recordBtn(context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(160, 40),
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.subPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: const Icon(Icons.mic),
      label: const Text(
        'Record Answer',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocalRecordScreen(
              questionnaire: widget.questionnaire,
              questionnaires: widget.questionnaires,
              survey: widget.survey,
              screen: "Question",
              addresses: widget.addresses,
              index: widget.index,
            ),
          ),
        );
      },
    );
  }
}
