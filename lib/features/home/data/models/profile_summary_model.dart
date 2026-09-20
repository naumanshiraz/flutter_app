import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';

part 'profile_summary_model.freezed.dart';
part 'profile_summary_model.g.dart';

@freezed
class CampusModel with _$CampusModel {
  const CampusModel._();

  const factory CampusModel({
    required String id,
    @JsonKey(name: 'development_name') required String developmentName,
    String? description,
    @JsonKey(name: 'thumb_url') String? thumbUrl,
  }) = _CampusModel;

  factory CampusModel.fromJson(Map<String, dynamic> json) => _$CampusModelFromJson(json);

  Campus toEntity() =>
      Campus(id: id, name: developmentName, description: description, thumbUrl: thumbUrl);
}

@freezed
class ProfileSummaryModel with _$ProfileSummaryModel {
  const ProfileSummaryModel._();

  const factory ProfileSummaryModel({
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default(<CampusModel>[]) List<CampusModel> campuses,
  }) = _ProfileSummaryModel;

  factory ProfileSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileSummaryModelFromJson(json);

  ProfileSummary toEntity() => ProfileSummary(
        name: fullName,
        email: email,
        phone: phoneNumber ?? '',
        avatarUrl: avatarUrl,
        campuses: campuses.map((c) => c.toEntity()).toList(),
      );
}
