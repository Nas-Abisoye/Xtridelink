import 'dart:convert';

FaQsModel faQsModelFromJson(String str) => FaQsModel.fromJson(json.decode(str));

class FaQsModel {
  final List<Faq> data;

  FaQsModel({
    required this.data,
  });

  factory FaQsModel.fromJson(Map<String, dynamic> json) => FaQsModel(
    data: List<Faq>.from(json['data'].map((x) => Faq.fromJson(x))),
  );
}

class Faq {
  final String question;
  final String answer;

  Faq({
    required this.question,
    required this.answer,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '');
}
