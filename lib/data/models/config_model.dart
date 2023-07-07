class Config {
  bool multipleAnswer = false;
  bool canAddOthers = false;
  bool useYesOrNo = false;
  bool isRequired = false;
  bool? enableAudioRecording = false;

  Config({
    required this.multipleAnswer,
    required this.canAddOthers,
    required this.useYesOrNo,
    required this.isRequired,
    this.enableAudioRecording,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      multipleAnswer: json['multipleAnswer'],
      canAddOthers: json['canAddOthers'],
      useYesOrNo: json['useYesOrNo'],
      isRequired: json['isRequired'],
      enableAudioRecording: json['enableAudioRecording'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'multipleAnswer': multipleAnswer,
      'canAddOthers': canAddOthers,
      'useYesOrNo': useYesOrNo,
      'isRequired': isRequired,
      'enableAudioRecording': enableAudioRecording,
    };
  }
}
