class Rate {
  String min;
  String max;

  Rate({
    required this.min,
    required this.max,
  });

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
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
