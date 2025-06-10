import 'package:json_annotation/json_annotation.dart';

part 'org_event.g.dart';

@JsonSerializable()
class OrgEvent {
  final int id;
  final String uuid;
  final String title;
  final String subtitle;
  final String category;
  final String date;
  final String? time;
  final String location;
  final int spotsLeft;
  final String? image;

  OrgEvent({
    required this.id,
    required this.uuid,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.date,
    this.time,
    required this.location,
    required this.spotsLeft,
    this.image,
  });

  factory OrgEvent.fromJson(Map<String, dynamic> json) =>
      _$OrgEventFromJson(json);
  Map<String, dynamic> toJson() => _$OrgEventToJson(this);
}
