class Dropdown {
  List<Result> result;

  Dropdown({
    required this.result,
  });

  factory Dropdown.fromJson(Map<String, dynamic> json) {
    var resultJson = json['result'] as List;
    List<Result> results = resultJson.map((e) => Result.fromJson(e)).toList();

    return Dropdown(
      result: results,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> results = result.map((e) => e.toJson()).toList();

    return {
      'result': results,
    };
  }
}

class Result {
  String label;
  int value;

  Result({
    required this.label,
    required this.value,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
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
