import 'package:pro/core/api/end_point.dart';

class ErrorModel {
  final int status;
  final String details;
  final String message;

  ErrorModel({
    required this.message,
    required this.status,
    required this.details,
  });
  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      status: jsonData[ApiKey.status],
      details: jsonData[ApiKey.details],
      message: jsonData[ApiKey.message],
    );
  }
}
