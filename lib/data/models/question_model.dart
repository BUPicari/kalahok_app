import 'dart:convert';

import 'choice_model.dart';
import 'config_model.dart';
import 'rate_model.dart';

class Question {
  int id = 0;
  String question = "";
  String type = "";
  List<Choice> choices = [];
  List<Rate> rates = [];
  Config config = Config(
    multipleAnswer: false,
    canAddOthers: false,
    useYesOrNo: false,
  );
  String addedAt = "";
  String updatedAt = "";
  Choice? selectedChoice;
  List<Choice>? selectedChoices;
  int? selectedRate;
  String? addedOthers;
  String? response;

  Question({
    required this.id,
    required this.question,
    required this.type,
    required this.choices,
    required this.config,
    required this.rates,
    required this.addedAt,
    required this.updatedAt,
    this.selectedChoice,
    this.selectedChoices,
    this.selectedRate,
    this.addedOthers,
    this.response,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var choicesJson = json['choices'] as List;
    List<Choice> choices = choicesJson.map((e) => Choice.fromJson(e)).toList();

    var ratesJson = json['rates'] as List;
    List<Rate> rates = ratesJson.map((e) => Rate.fromJson(e)).toList();

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

    return "'$response'";
  }
}
