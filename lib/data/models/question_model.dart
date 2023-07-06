import 'dart:convert';

import 'package:flutter/material.dart';

import 'choice_model.dart';
import 'config_model.dart';
import 'rate_model.dart';
import 'label_model.dart';

class Question {
  int id = 0;
  String question = "";
  String type = "";
  List<Choice> choices = [];
  List<Rate> rates = [];
  List<Label> labels = [];
  Config config = Config(
    multipleAnswer: false,
    canAddOthers: false,
    useYesOrNo: false,
    isRequired: true,
    enableAudioRecording: true,
  );
  String addedAt = "";
  String updatedAt = "";
  Choice? selectedChoice;
  List<Choice>? selectedChoices;
  // List<String>? selected;
  int? selectedRate;
  String? addedOthers;
  String? response;

  Question({
    required this.id,
    required this.question,
    required this.type,
    required this.choices,
    required this.rates,
    required this.labels,
    required this.config,
    required this.addedAt,
    required this.updatedAt,
    this.selectedChoice,
    this.selectedChoices,
    // this.selected,
    this.selectedRate,
    this.addedOthers,
    this.response,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var choicesJson = json['choices'] as List;
    List<Choice> choices = choicesJson.map((e) => Choice.fromJson(e)).toList();

    var ratesJson = json['rates'] as List;
    List<Rate> rates = ratesJson.map((e) => Rate.fromJson(e)).toList();

    var labelsJson = json['labels'] as List;
    List<Label> labels = labelsJson.map((e) => Label.fromJson(e)).toList();

    var config = Config.fromJson(json['config']);

    if (json['type'] == "trueOrFalse") {
      choices.add(Choice(name: config.useYesOrNo ? 'Yes' : 'True'));
      choices.add(Choice(name: config.useYesOrNo ? 'No' : 'False'));
    }

    if (rates.isEmpty && json['type'] == "rating") {
      rates.add(Rate(min: "1", max: "10"));
    }

    return Question(
      id: json['id'],
      question: json['question'],
      type: json['type'],
      choices: choices,
      rates: rates,
      labels: labels,
      config: config,
      addedAt: json['added_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type,
      'choices': choices, // add toJson in Choice model
      'rates': rates, // add toJson in Rate model
      'labels': labels, // add toJson in Label model
      'config': config, // add toJson in Config model
      'added_at': addedAt,
      'updated_at': updatedAt,
      'response': response,
    };
  }

  String getAnswer() {
    var selected = <String>[];

    if (config.multipleAnswer) {
      selected = response.toString().split(',');

      return jsonEncode({
        'selected': selected,
        'others': addedOthers,
      });
    }

    if (config.canAddOthers) {
      selected.add(response.toString());

      return jsonEncode({
        'selected': selected,
        'others': addedOthers,
      });
    }

    return response.toString();
  }

  Widget getReviewResponse() {
    var arrResponses = <String>[];
    String answer = response.toString();

    if (config.multipleAnswer ||
        config.canAddOthers ||
        type == 'openEnded' ||
        type == 'dropdown') {
      if (config.multipleAnswer) {
        arrResponses = answer != 'null' ? answer.split(',') : arrResponses;
      } else if (config.canAddOthers) {
        var decoded = jsonDecode(answer);
        decoded != null ? arrResponses.add(answer) : arrResponses;
      } else {
        var decoded = jsonDecode(answer);
        arrResponses =
            decoded != null ? List<String>.from(decoded as List) : arrResponses;
      }

      List<Widget> selected = arrResponses.map(
        (res) {
          String r = res.replaceAll('"', '');
          String ans = 'Answer (${arrResponses.indexOf(res) + 1}):  $r';
          if (arrResponses.length == 1) {
            ans = 'Answer: $r';
          }
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
        },
      ).toList();

      Widget addOthersWidget = Column();
      final addedOthers = this.addedOthers;
      String othersOrSpecifyText =
          type == 'trueOrFalse' ? 'Specify:' : 'Others:';

      if (addedOthers != null) {
        addOthersWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              '$othersOrSpecifyText ${addedOthers.replaceAll('"', '')}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: selected,
          ),
          addOthersWidget,
        ],
      );
    }

    return Text(
      jsonDecode(answer) != null
          ? 'Answer:  ${answer.replaceAll('"', '')}'
          : '',
      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
    );
  }
}
