import 'data.dart';

class PaymentAccountResponse {
  String? status;
  String? message;
  PaymentAccount? data;

  PaymentAccountResponse({this.status, this.message, this.data});

  @override
  String toString() {
    return 'PaymentAccountResponse(status: $status, message: $message, data: $data)';
  }

  factory PaymentAccountResponse.fromJson(Map<String, dynamic> json) {
    return PaymentAccountResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : PaymentAccount.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
