import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';

part 'profile_summary_model.freezed.dart';
part 'profile_summary_model.g.dart';

@freezed
class ProfileSummaryModel with _$ProfileSummaryModel {
  const ProfileSummaryModel._();

  const factory ProfileSummaryModel({
    required String name,
    required String email,
    required String phone,
    String? avatarUrl,
  }) = _ProfileSummaryModel;

  factory ProfileSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileSummaryModelFromJson(json);

  ProfileSummary toEntity() =>
      ProfileSummary(name: name, email: email, phone: phone, avatarUrl: avatarUrl);
}
