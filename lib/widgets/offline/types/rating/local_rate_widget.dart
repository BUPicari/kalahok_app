import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:kalahok_app/data/models/offline/questionnaire.dart';
import 'package:kalahok_app/data/models/offline/response.dart';
import 'package:kalahok_app/helpers/variables.dart';

class LocalRateWidget extends StatefulWidget {
  final Questionnaire questionnaire;
  final ValueChanged<Response> onSetResponse;

  const LocalRateWidget({
    Key? key,
    required this.questionnaire,
    required this.onSetResponse,
  }) : super(key: key);

  @override
  State<LocalRateWidget> createState() => _LocalRateWidgetState();
}

class _LocalRateWidgetState extends State<LocalRateWidget> {
  List<String> selected = [];
  List<String> fieldTexts = [];

  @override
  void initState() {
    super.initState();

    selected = widget.questionnaire.response?.responses ?? [];
    fieldTexts = List.generate(1, (i) => widget.questionnaire.question);
  }

  @override
  Widget build(BuildContext context) {
    final stars =
      List<Widget>.generate(int.parse(widget.questionnaire.rates[0].max), (index) {
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
          children: widget.questionnaire.labels.map((label) {
            return Text(
              label.name,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingStar({ required Color containerColor }) {
    return Icon(
      Icons.star_border_outlined,
      color: containerColor,
      size: 30,
    );
  }

  Color _getColorForRate({ required int rate }) {
    int selectedRate = selected.isEmpty ? -1 : int.parse(selected[0]) - 1;
    final isSelected = rate <= selectedRate;

    if (!isSelected) {
      return AppColor.secondary;
    } else {
      return AppColor.warning;
    }
  }

  void _setRate({ required int rate }) {
    setState(() {
      String strRate = jsonEncode(rate+1);
      selected.isEmpty ? selected.add(strRate) : selected[0] = strRate;
    });
    _setResponse();
  }

  void _setResponse() {
    widget.onSetResponse(Response(
      surveyQuestion: widget.questionnaire.question,
      questionFieldTexts: fieldTexts,
      responses: selected,
      otherResponse: '',
    ));
  }
}
