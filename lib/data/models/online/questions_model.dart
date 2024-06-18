import 'dart:convert';

import 'answer_model.dart';
import 'choice_model.dart';
import 'config_model.dart';
import 'rate_model.dart';
import 'label_model.dart';

class Questions {
  int id;
  int? surveyId;
  String question;
  String type;
  List<Choice> choices;
  List<Rate> rates;
  List<Label> labels;
  Config config;
  String addedAt;
  String updatedAt;
  Answer? answer;
  bool? hasRecording = false;
  bool? hasInput = false;

  Questions({
    required this.id,
    this.surveyId,
    required this.question,
    required this.type,
    required this.choices,
    required this.rates,
    required this.labels,
    required this.config,
    required this.addedAt,
    required this.updatedAt,
    this.answer,
    this.hasRecording,
    this.hasInput,
  });

  factory Questions.fromJson(Map<String, dynamic> data) {
    var choicesJson = data['choices'].runtimeType == String ?
      json.decode(data['choices']) as List :
      data['choices'] as List;
    List<Choice> choices = choicesJson.isNotEmpty ?
      choicesJson.map((e) => Choice.fromJson(e)).toList() : [];

    var ratesJson = data['rates'].runtimeType == String ?
      json.decode(data['rates']) as List :
      data['rates'] as List;
    List<Rate> rates = ratesJson.isNotEmpty ?
      ratesJson.map((e) => Rate.fromJson(e)).toList() : [];

    var labelsJson = data['labels'].runtimeType == String ?
      json.decode(data['labels']) as List :
      data['labels'] as List;
    List<Label> labels = labelsJson.isNotEmpty ?
      labelsJson.map((e) => Label.fromJson(e)).toList() : [];

    Config config = data['config'].runtimeType == String ?
      Config.fromJson(json.decode(data['config'])) :
      Config.fromJson(data['config']);

    if (data['type'] == "trueOrFalse") {
      choices.add(Choice(name: config.useYesOrNo ? 'Yes' : 'True'));
      choices.add(Choice(name: config.useYesOrNo ? 'No' : 'False'));
    }

    if (rates.isEmpty && data['type'] == "rating") {
      rates.add(Rate(min: "1", max: "10"));
    }

    return Questions(
      id: data['id'],
      surveyId: data['survey_id'],
      question: data['question'],
      type: data['type'],
      choices: choices,
      rates: rates,
      labels: labels,
      config: config,
      addedAt: data['added_at'],
      updatedAt: data['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> c = choices.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> r = rates.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> l = labels.map((e) => e.toJson()).toList();
    Map<String, dynamic> conf = config.toJson();

    return {
      'id': id,
      'survey_id': surveyId,
      'question': question,
      'type': type,
      'choices': json.encode(c),
      'rates': json.encode(r),
      'labels': json.encode(l),
      'config': json.encode(conf),
      'added_at': addedAt,
      'updated_at': updatedAt,
    };
  }
}
