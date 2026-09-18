import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    String? gender,
    @JsonKey(name: 'custom_gender') String? customGender,
    String? location,
    @JsonKey(name: 'onboarding_complete') @Default(false) bool onboardingComplete,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  factory UserProfileModel.fromEntity(UserProfile entity) => UserProfileModel(
        fullName: entity.name,
        birthDate: entity.birthDate,
        gender: entity.gender?.name,
        customGender: entity.customGender,
        location: entity.location,
      );

  UserProfile toEntity() => UserProfile(
        name: fullName,
        birthDate: birthDate,
        gender: gender == null
            ? null
            : Gender.values.firstWhere((g) => g.name == gender, orElse: () => Gender.other),
        customGender: customGender,
        location: location,
      );

  Map<String, dynamic> toRequestJson() => {
        'full_name': fullName,
        if (birthDate != null)
          'birth_date':
              '${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}',
        if (gender != null) 'gender': gender,
        if (customGender != null) 'custom_gender': customGender,
        if (location != null) 'location': location,
      };
}
