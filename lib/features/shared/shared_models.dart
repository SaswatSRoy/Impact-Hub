import 'package:flutter/material.dart';

@immutable
class AppUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });
}

@immutable
class EventModel {
  final String id;
  final String title;
  final String? image;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;
  final String category;
  final int participants;
  final int? maxParticipants;
  final Map<String, dynamic>? location;
  final List<String>? participantIds; // ✅ added

  const EventModel({
    required this.id,
    required this.title,
    required this.startDate,
    this.endDate,
    this.image,
    this.description = '',
    this.category = 'General',
    this.participants = 0,
    this.maxParticipants,
    this.location,
    this.participantIds,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'],
      description: json['description'] ?? '',
      category: json['category'] ?? 'Other',
      participants: (json['participants'] as List?)?.length ?? 0,
      participantIds: (json['participants'] as List?)
          ?.map((p) => p is String ? p : p['_id'] as String)
          .toList(),
      startDate: DateTime.parse(json['startDate']),
      endDate:
          json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      maxParticipants: json['maxParticipants'],
      location: json['location'] != null
          ? Map<String, dynamic>.from(json['location'])
          : null,
    );
  }
}

@immutable
class CommunityModel {
  final String id;
  final String name;
  final String? image;
  final String description;
  final int members;
  final bool verified;

  const CommunityModel({
    required this.id,
    required this.name,
    this.image,
    this.description = '',
    this.members = 0,
    this.verified = false,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      description: json['description'] ?? '',
      members: (json['members'] as List?)?.length ?? 0,
      verified: json['verificationStatus'] == 'verified',
    );
  }
}

@immutable
class MetricsModel {
  final int eventsAttended;
  final int communitiesJoined;
  final int totalPoints;
  final double hoursVolunteered;

  const MetricsModel({
    this.eventsAttended = 0,
    this.communitiesJoined = 0,
    this.totalPoints = 0,
    this.hoursVolunteered = 0.0,
  });

  factory MetricsModel.fromJson(Map<String, dynamic> json) {
    return MetricsModel(
      eventsAttended: json['eventsAttended'] ?? 0,
      communitiesJoined: json['communitiesJoined'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
      hoursVolunteered:
          (json['hoursVolunteered'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

String fmtDateShort(DateTime d) => '${d.day}/${d.month}/${d.year}';
