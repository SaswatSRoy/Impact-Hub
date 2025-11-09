// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      location: json['location'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      points: (json['points'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt(),
      joinedEvents:
          (json['joinedEvents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      joinedCommunities:
          (json['joinedCommunities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'location': instance.location,
      'avatarUrl': instance.avatarUrl,
      'points': instance.points,
      'level': instance.level,
      'joinedEvents': instance.joinedEvents,
      'joinedCommunities': instance.joinedCommunities,
    };
