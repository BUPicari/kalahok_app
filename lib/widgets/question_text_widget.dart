import 'package:flutter/material.dart';
import 'package:kalahok_app/helpers/variables.dart';
import 'package:kalahok_app/services/text_to_speech_service.dart';

class QuestionTextWidget extends StatefulWidget {
  final bool isRequired;
  final String question;

  const QuestionTextWidget({
    Key? key,
    required this.isRequired,
    required this.question,
  }) : super(key: key);

  @override
  State<QuestionTextWidget> createState() => _QuestionTextWidgetState();
}

class _QuestionTextWidgetState extends State<QuestionTextWidget> {
  late TextToSpeechService textToSpeechService;

  @override
  void initState() {
    super.initState();
    textToSpeechService = TextToSpeechService();
    textToSpeechService.init();
  }

  @override
  void dispose() {
    super.dispose();
    textToSpeechService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRequired) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '* This question is required',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 16,
              color: AppColor.darkError,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  textToSpeechService.textToSpeech(text: widget.question);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.volume_up,
                      color: AppColor.subPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Text(
      widget.question,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }
}
