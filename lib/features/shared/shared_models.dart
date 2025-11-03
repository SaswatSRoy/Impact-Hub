
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
  final String description;
  final String category;
  final int participants;

  const EventModel({
    required this.id,
    required this.title,
    required this.startDate,
    this.image,
    this.description = '',
    this.category = 'General',
    this.participants = 0,
  });
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
}

// --- UI Helpers ---
String fmtDateShort(DateTime d) => '${d.day}/${d.month}/${d.year}';
