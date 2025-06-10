// models/applicant_profile.dart
class ApplicantProfile {
  final int id;
  final String name;
  final String email;
  final String role;
  final String city;
  final String phone;
  final String bio;
  final List<String> skills;
  final List<String> interests;

  ApplicantProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.city,
    required this.phone,
    required this.bio,
    required this.skills,
    required this.interests,
  });
  factory ApplicantProfile.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};

    return ApplicantProfile(
      id: user['id'] ?? 0,
      name: user['name'] ?? 'Unknown',
      email: user['email'] ?? 'No email',
      role: user['role'] ?? 'Unknown',
      city: user['city'] ?? 'Unknown',
      phone: user['phone'] ?? 'No phone',
      bio: user['bio'] ?? '',
      skills: List<String>.from(user['skills'] ?? []),
      interests: List<String>.from(user['interests'] ?? []),
    );
  }


  // factory ApplicantProfile.fromJson(Map<String, dynamic> json) {
  //   final user = json['user'];
  //   return ApplicantProfile(
  //     id: user['id'],
  //     name: user['name'],
  //     email: user['email'],
  //     role: user['role'],
  //     city: user['city'],
  //     phone: user['phone'],
  //     bio: user['bio'],
  //     skills: List<String>.from(user['skills']),
  //     interests: List<String>.from(user['interests']),
  //   );
  // }
}
