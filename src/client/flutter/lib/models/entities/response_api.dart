class ResponseAPI {
  String status;
  String? message;
  int code;
  dynamic data;

  ResponseAPI({
    required this.status,
    this.message,
    required this.code,
    this.data,
  });

  ResponseAPI.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        message = json["message"],
        code = json["code"],
        data = json["data"];

}
