class ApplicationModel {
  final String id;
  final String eventId;
  final String title;
  final String status;
  final String subtitle;
  final String category;
  final String organization; // added organizationId
  final String date;
  final String? time; // nullable
  final String appliedDate;

  ApplicationModel({
    required this.id,
    required this.organization, // added organizationId
    required this.eventId,
    required this.title,
    required this.status,
    required this.subtitle,
    required this.category,
    required this.date,
    required this.time,
    required this.appliedDate,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      organization:  '',
      id: json['id'] ?? '',
      eventId: json['eventId'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      subtitle: json['subtitle'] ?? '',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      time: json['time'], // can be null
      appliedDate: json['appliedAt'] ?? '',
    );
  }
}
