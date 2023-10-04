import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/helpers/utils.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/record_screen.dart';

class RecordAnswerWidget extends StatefulWidget {
  final Questions question;

  const RecordAnswerWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  State<RecordAnswerWidget> createState() => _RecordAnswerWidgetState();
}

class _RecordAnswerWidgetState extends State<RecordAnswerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils.buildAudioFile(
        questionId: widget.question.id,
        surveyId: widget.question.surveyId ?? 0
      ),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              _recordBtn(context),
              const SizedBox(width: 10),
              snapshot.data
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
            builder: (context) => RecordScreen(question: widget.question),
          ),
        );
      },
    );
  }
}
