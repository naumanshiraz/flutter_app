import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/residency/domain/entities/campus_option.dart';

part 'campus_option_model.freezed.dart';
part 'campus_option_model.g.dart';

/// A row from `GET /api/app/campuses` — just enough for the "Campuses or
/// project" dropdown (id to save, name to display).
@freezed
class CampusOptionModel with _$CampusOptionModel {
  const CampusOptionModel._();

  const factory CampusOptionModel({
    required String id,
    @JsonKey(name: 'development_name') required String developmentName,
  }) = _CampusOptionModel;

  factory CampusOptionModel.fromJson(Map<String, dynamic> json) =>
      _$CampusOptionModelFromJson(json);

  CampusOption toEntity() => CampusOption(id: id, name: developmentName);
}
