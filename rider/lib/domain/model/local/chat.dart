class ChatTextModel {
  String message;
  String senderId;
  String roomId;
  String receiverId;
  DateTime time;
  ChatTextModel(
      {required this.message,
      required this.senderId,
      required this.receiverId,
      required this.time,
      required this.roomId});

  factory ChatTextModel.fromMap(Map<String, dynamic> map) => ChatTextModel(
      message: map['message'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      roomId: map['roomId'] ?? '',
      time: DateTime.tryParse(map['time'])?.toLocal() ?? DateTime.now());

  factory ChatTextModel.fromJson(Map<String, dynamic> json) => ChatTextModel(
        time: DateTime.tryParse(json['createdAt'])?.toLocal() ?? DateTime.now(),
        senderId: json['senderId'] ?? '',
        receiverId: json['recieverId'] ?? '',
        message: json['message'] ?? '',
        roomId: json['roomId'] ?? '',
      );

  Map<String, dynamic> get toMap => {
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'roomId': roomId,
        'time': time.toUtc().toIso8601String()
      };
}

class ChatTextModelRes {
  List<ChatTextModel> data;

  ChatTextModelRes({
    required this.data,
  });

  factory ChatTextModelRes.fromJson(Map<String, dynamic> json) =>
      ChatTextModelRes(
          data: List<ChatTextModel>.from(
              (json['data'] ?? []).map((x) => ChatTextModel.fromJson(x))));
}
