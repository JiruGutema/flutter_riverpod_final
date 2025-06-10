class Applicant {
  final int userId;
  final String name;
  final String email;
  final String status;
  final DateTime appliedAt;

  Applicant({
    required this.userId,
    required this.name,
    required this.email,
    required this.status,
    required this.appliedAt,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
      appliedAt: DateTime.parse(json['applied_at']),
    );
  }
}
