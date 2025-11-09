import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String email,
    String? location,
    String? avatarUrl,
    int? points,
    int? level,
    @Default([]) List<String> joinedEvents,
    @Default([]) List<String> joinedCommunities,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
