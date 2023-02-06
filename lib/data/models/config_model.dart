class Config {
  bool multipleAnswer = false;
  bool canAddOthers = false;
  bool useYesOrNo = false;
  bool isRequired = false;

  Config({
    required this.multipleAnswer,
    required this.canAddOthers,
    required this.useYesOrNo,
    required this.isRequired,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      multipleAnswer: json['multipleAnswer'],
      canAddOthers: json['canAddOthers'],
      useYesOrNo: json['useYesOrNo'],
      isRequired: json['isRequired'],
    );
  }
}
