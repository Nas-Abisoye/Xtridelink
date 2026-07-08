class NotificationResModel {
  List<NotificationData> data;

  NotificationResModel({
    required this.data,
  });

  factory NotificationResModel.fromJson(Map<String, dynamic> json) =>
      NotificationResModel(
          data: List<NotificationData>.from((json['results'] ?? [])
              .map((x) => NotificationData.fromJson(x))));
}

class NotificationData {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String title;
  String message;
  String type;
  dynamic automated;
  String recipientType;
  dynamic trigger;
  dynamic scheduleDate;
  dynamic scheduleTime;
  String messageType;
  String status;
  bool isTrash;

  NotificationData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.message,
    required this.type,
    required this.automated,
    required this.recipientType,
    required this.trigger,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.messageType,
    required this.status,
    required this.isTrash,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json['id'] ?? '',
        createdAt: DateTime.parse(
            json['createdAt'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json['updatedAt'] ?? DateTime.now().toIso8601String()),
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        type: json['type'] ?? '',
        automated: json['automated'],
        recipientType: json['recipientType'] ?? '',
        trigger: json['trigger'],
        scheduleDate: json['scheduleDate'],
        scheduleTime: json['scheduleTime'],
        messageType: json['messageType'] ?? '',
        status: json['status'] ?? '',
        isTrash: json['isTrash'] ?? false,
      );
}
