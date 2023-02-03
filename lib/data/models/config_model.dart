class Config {
  bool multipleAnswer = false;
  bool canAddOthers = false;
  bool useYesOrNo = false;

  Config({
    required this.multipleAnswer,
    required this.canAddOthers,
    required this.useYesOrNo,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      multipleAnswer: json['multipleAnswer'],
      canAddOthers: json['canAddOthers'],
      useYesOrNo: json['useYesOrNo'],
    );
  }
}
