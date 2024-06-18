class ServerUrl {
  String url;
  String apiKey;

  ServerUrl({
    required this.url,
    required this.apiKey,
  });

  factory ServerUrl.fromJson(Map<String, dynamic> json) {
    return ServerUrl(
      url: json['url'],
      apiKey: json['apiKey'],
    );
  }
}
