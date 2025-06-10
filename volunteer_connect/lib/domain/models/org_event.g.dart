// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'org_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrgEvent _$OrgEventFromJson(Map<String, dynamic> json) => OrgEvent(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  category: json['category'] as String,
  date: json['date'] as String,
  time: json['time'] as String?,
  location: json['location'] as String,
  spotsLeft: (json['spotsLeft'] as num).toInt(),
  image: json['image'] as String?,
);

Map<String, dynamic> _$OrgEventToJson(OrgEvent instance) => <String, dynamic>{
  'id': instance.id,
  'uuid': instance.uuid,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'category': instance.category,
  'date': instance.date,
  'time': instance.time,
  'location': instance.location,
  'spotsLeft': instance.spotsLeft,
  'image': instance.image,
};
