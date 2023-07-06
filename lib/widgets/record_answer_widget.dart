import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/screens/record_screen.dart';
// import 'package:kalahok_app/widgets/audio_widget.dart';

class RecordAnswerWidget extends StatelessWidget {
  final Questions question;

  const RecordAnswerWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            builder: (context) => RecordScreen(question: question),
            // builder: (context) => const AudioWidget(),
          ),
        );
      },
    );
  }
}
