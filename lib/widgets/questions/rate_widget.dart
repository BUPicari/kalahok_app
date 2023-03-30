import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kalahok_app/data/models/answer_model.dart';
import 'package:kalahok_app/data/models/questions_model.dart';
import 'package:kalahok_app/helpers/variables.dart';

class RateWidget extends StatefulWidget {
  final Questions question;
  final ValueChanged<Answer> onSetResponse;

  const RateWidget({
    Key? key,
    required this.question,
    required this.onSetResponse,
  }) : super(key: key);

  @override
  State<RateWidget> createState() => _RateWidgetState();
}

class _RateWidgetState extends State<RateWidget> {
  List<String> selected = [];
  List<String> fieldTexts = [];

  @override
  void initState() {
    super.initState();

    selected = widget.question.answer?.answers ?? [];
    fieldTexts = List.generate(1, (i) => widget.question.question);
  }

  @override
  Widget build(BuildContext context) {
    final stars =
        List<Widget>.generate(int.parse(widget.question.rates[0].max), (index) {
      final containerColor = _getColorForRate(rate: index);
      return GestureDetector(
        onTap: () => _setRate(rate: index),
        child: _buildRatingStar(containerColor: containerColor),
      );
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: stars,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.question.labels.map((label) {
            return Text(
              label.name,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingStar({required Color containerColor}) {
    return Icon(
      Icons.star_border_outlined,
      color: containerColor,
      size: 30,
    );
  }

  Color _getColorForRate({required int rate}) {
    int selectedRate = selected.isEmpty ? -1 : int.parse(selected[0]) - 1;
    final isSelected = rate <= selectedRate;

    if (!isSelected) {
      return AppColor.secondary;
    } else {
      return AppColor.warning;
    }
  }

  void _setRate({required int rate}) {
    setState(() {
      String strRate = jsonEncode(rate+1);
      selected.isEmpty ? selected.add(strRate) : selected[0] = strRate;
    });
    _setResponse();
  }

  void _setResponse() {
    widget.onSetResponse(Answer(
      surveyQuestion: widget.question.question,
      questionFieldTexts: fieldTexts,
      answers: selected,
      otherAnswer: '',
    ));
  }
}
