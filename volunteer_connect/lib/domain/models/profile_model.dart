class Profile {
  final int id;
  final String name;
  final String email;
  final String role;
  final String city;
  final String phone;
  final String bio;
  final int attendedEvents;
  final int hoursVolunteered;
  final List<String> skills;
  final List<String> interests;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.city,
    required this.phone,
    required this.bio,
    required this.attendedEvents,
    required this.hoursVolunteered,
    required this.skills,
    required this.interests,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      city: json['city'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? '',
      attendedEvents: json['attended_events'] ?? 0,
      hoursVolunteered: json['hours_volunteered'] ?? 0,
      skills: List<String>.from(json['skills'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'city': city,
    'phone': phone,
    'bio': bio,
    'skills': skills,
    'interests': interests,
  };
}