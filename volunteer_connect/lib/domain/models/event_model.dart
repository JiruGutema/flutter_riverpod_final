import 'dart:convert';

class EventModel {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String date;
  final String time;
  final String location;
  final int spotsLeft;
  final String description;
  final Map<String, dynamic> requirements;
  final Map<String, dynamic> additionalInfo;
  final String contactPhone;
  final String contactEmail;
  final String contactTelegram;

  EventModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.spotsLeft,
    required this.description,
    required this.requirements,
    required this.additionalInfo,
    required this.contactPhone,
    required this.contactEmail,
    required this.contactTelegram,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json['id'].toString(),
    title: json['title'] ?? '',
    subtitle: json['subtitle'] ?? '',
    category: json['category'] ?? '',
    date: json['date'] ?? '',
    time: json['time'] ?? '',
    location: json['location'] ?? '',
    spotsLeft:
        json['spotsLeft'] is int
            ? json['spotsLeft']
            : int.tryParse(json['spotsLeft'].toString()) ?? 0,
    description: json['description'] ?? '',
    requirements: _parseMap(json['requirements']),
    additionalInfo: _parseMap(json['additionalInfo']),
    contactPhone: json['contactPhone'] ?? '',
    contactEmail: json['contactEmail'] ?? '',
    contactTelegram: json['contactTelegram'] ?? '',
  );

  static Map<String, dynamic> _parseMap(dynamic value) {
    if (value == null) return {};
    if (value is Map<String, dynamic>) return value;
    if (value is String) {
      try {
        final decoded = jsonDecode(value);
        return decoded is Map<String, dynamic> ? decoded : {};
      } catch (_) {
        return {};
      }
    }
    return {};
  }
}
