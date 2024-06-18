import 'dart:convert';

class SurveyWithQuestionnaires {
  int id;
  int detailsId;
  String title;
  String description;
  String waiver;
  String startDate;
  String endDate;
  int status;
  LanguageInSurveyWithQuestionnaires language;
  List<QuestionsInSurveyWithQuestionnaires> questionnaires;

  SurveyWithQuestionnaires({
    required this.id,
    required this.detailsId,
    required this.title,
    required this.description,
    required this.waiver,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.language,
    required this.questionnaires,
  });

  factory SurveyWithQuestionnaires.fromJson(Map<String, dynamic> json) {
    var languageJson = json['language'];
    LanguageInSurveyWithQuestionnaires tempLanguage =
      LanguageInSurveyWithQuestionnaires.fromJson(languageJson);

    var questionnairesJson = json['questionnaires'] as List;
    List<QuestionsInSurveyWithQuestionnaires> tempQuestionnaires =
      questionnairesJson.map((e) => QuestionsInSurveyWithQuestionnaires.fromJson(e)).toList();

    return SurveyWithQuestionnaires(
      id: json['id'],
      detailsId: json['detailsId'],
      title: json['title'],
      description: json['description'],
      waiver: json['waiver'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'] == true ? 1 : 0,
      language: tempLanguage,
      questionnaires: tempQuestionnaires,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> tempLanguage = language.toJson();
    List<Map<String, dynamic>> tempQuestionnaires =
      questionnaires.map((e) => e.toJson()).toList();

    return {
      'id': id,
      'detailsId': detailsId,
      'title': title,
      'description': description,
      'waiver': waiver,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'language': tempLanguage,
      'questionnaires': tempQuestionnaires,
    };
  }
}

class LanguageInSurveyWithQuestionnaires {
  int id;
  String name;

  LanguageInSurveyWithQuestionnaires({
    required this.id,
    required this.name,
  });

  factory LanguageInSurveyWithQuestionnaires.fromJson(Map<String, dynamic> json) {
    return LanguageInSurveyWithQuestionnaires(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class QuestionsInSurveyWithQuestionnaires {
  int id;
  String question;
  String type;
  List<ChoicesInSurveyWithQuestionnaires> choices;
  ConfigInSurveyWithQuestionnaires configs;
  List<LabelsInSurveyWithQuestionnaires> labels;
  List<RatesInSurveyWithQuestionnaires> rates;

  QuestionsInSurveyWithQuestionnaires({
    required this.id,
    required this.question,
    required this.type,
    required this.choices,
    required this.configs,
    required this.labels,
    required this.rates,
  });

  factory QuestionsInSurveyWithQuestionnaires.fromJson(Map<String, dynamic> data) {
    var choicesJson = data['choices'].runtimeType == String ?
      json.decode(data['choices']) as List : data['choices'] as List;
    List<ChoicesInSurveyWithQuestionnaires> tempChoices = choicesJson.isNotEmpty ?
      choicesJson.map((e) => ChoicesInSurveyWithQuestionnaires.fromJson(e)).toList() : [];

    var labelsJson = data['labels'].runtimeType == String ?
      json.decode(data['labels']) as List : data['labels'] as List;
    List<LabelsInSurveyWithQuestionnaires> tempLabels = labelsJson.isNotEmpty ?
      labelsJson.map((e) => LabelsInSurveyWithQuestionnaires.fromJson(e)).toList() : [];

    var ratesJson = data['rates'].runtimeType == String ?
      json.decode(data['rates']) as List : data['rates'] as List;
    List<RatesInSurveyWithQuestionnaires> tempRates = ratesJson.isNotEmpty ?
      ratesJson.map((e) => RatesInSurveyWithQuestionnaires.fromJson(e)).toList() : [];

    ConfigInSurveyWithQuestionnaires tempConfig = data['config'].runtimeType == String ?
      ConfigInSurveyWithQuestionnaires.fromJson(json.decode(data['config'])) :
      ConfigInSurveyWithQuestionnaires.fromJson(data['config']);

    if (data['type'] == "trueOrFalse") {
      tempChoices.add(ChoicesInSurveyWithQuestionnaires(name: tempConfig.useYesOrNo ? 'Yes' : 'True'));
      tempChoices.add(ChoicesInSurveyWithQuestionnaires(name: tempConfig.useYesOrNo ? 'No' : 'False'));
    }

    if (tempRates.isEmpty && data['type'] == "rating") {
      tempRates.add(RatesInSurveyWithQuestionnaires(min: "1", max: "10"));
    }

    return QuestionsInSurveyWithQuestionnaires(
      id: data['id'],
      question: data['question'],
      type: data['type'],
      choices: tempChoices,
      configs: tempConfig,
      labels: tempLabels,
      rates: tempRates,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> tempChoices = choices.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> tempRates = rates.map((e) => e.toJson()).toList();
    List<Map<String, dynamic>> tempLabels = labels.map((e) => e.toJson()).toList();
    Map<String, dynamic> tempConfigs = configs.toJson();

    return {
      'id': id,
      'question': question,
      'type': type,
      'choices': json.encode(tempChoices),
      'config': json.encode(tempConfigs),
      'labels': json.encode(tempLabels),
      'rates': json.encode(tempRates),
    };
  }
}

class ChoicesInSurveyWithQuestionnaires {
  String name;

  ChoicesInSurveyWithQuestionnaires({
    required this.name,
  });

  factory ChoicesInSurveyWithQuestionnaires.fromJson(Map<String, dynamic> json) {
    return ChoicesInSurveyWithQuestionnaires(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class ConfigInSurveyWithQuestionnaires {
  bool isRequired = false;
  bool multipleAnswer = false;
  bool canAddOthers = false;
  bool useYesOrNo = false;
  bool? uploadAttachments = false;
  bool? enableAudioRecording = false;
  bool? useStaticDropdown = false;

  ConfigInSurveyWithQuestionnaires({
    required this.isRequired,
    required this.multipleAnswer,
    required this.canAddOthers,
    required this.useYesOrNo,
    this.uploadAttachments,
    this.enableAudioRecording,
    this.useStaticDropdown,
  });

  factory ConfigInSurveyWithQuestionnaires.fromJson(Map<String, dynamic> json) {
    return ConfigInSurveyWithQuestionnaires(
      isRequired: json['isRequired'],
      multipleAnswer: json['multipleAnswer'],
      canAddOthers: json['canAddOthers'],
      useYesOrNo: json['useYesOrNo'],
      uploadAttachments: json['uploadAttachments'],
      enableAudioRecording: json['enableAudioRecording'],
      useStaticDropdown: json['useStaticDropdown'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isRequired': isRequired,
      'multipleAnswer': multipleAnswer,
      'canAddOthers': canAddOthers,
      'useYesOrNo': useYesOrNo,
      'uploadAttachments': uploadAttachments,
      'enableAudioRecording': enableAudioRecording,
      'useStaticDropdown': useStaticDropdown,
    };
  }
}

class LabelsInSurveyWithQuestionnaires {
  String name;
  String endpoint;

  LabelsInSurveyWithQuestionnaires({
    required this.name,
    required this.endpoint,
  });

  factory LabelsInSurveyWithQuestionnaires.fromJson(Map<String, dynamic> json) {
    return LabelsInSurveyWithQuestionnaires(
      name: json['name'],
      endpoint: json['endpoint'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'endpoint': endpoint,
    };
  }
}

class RatesInSurveyWithQuestionnaires {
  String min;
  String max;

  RatesInSurveyWithQuestionnaires({
    required this.min,
    required this.max,
  });

  factory RatesInSurveyWithQuestionnaires.fromJson(Map<String, dynamic> json) {
    return RatesInSurveyWithQuestionnaires(
      min: json['min'],
      max: json['max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}

class DropdownInSurveyWithQuestionnaires {
  List<DropdownResultInSurveyWithQuestionnaires> result;
  int hasMore;

  DropdownInSurveyWithQuestionnaires({
    required this.result,
    required this.hasMore,
  });

  factory DropdownInSurveyWithQuestionnaires.fromJson(Map<String, dynamic> json) {
    var resultJson = json['result'] as List;
    List<DropdownResultInSurveyWithQuestionnaires> results =
      resultJson.map((e) => DropdownResultInSurveyWithQuestionnaires.fromJson(e)).toList();

    return DropdownInSurveyWithQuestionnaires(
      result: results,
      hasMore: json['has_more'] == true ? 1 : 0,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> results = result.map((e) => e.toJson()).toList();

    return {
      'result': results,
      'has_more': hasMore,
    };
  }
}

class DropdownResultInSurveyWithQuestionnaires {
  String label;
  int value;

  DropdownResultInSurveyWithQuestionnaires({
    required this.label,
    required this.value,
  });

  factory DropdownResultInSurveyWithQuestionnaires.fromJson(Map<String, dynamic> json) {
    return DropdownResultInSurveyWithQuestionnaires(
      label: json['label'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }
}
