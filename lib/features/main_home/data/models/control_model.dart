import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/main_home/domain/entities/control.dart';

part 'control_model.freezed.dart';
part 'control_model.g.dart';

@freezed
class ControlModel with _$ControlModel {
  const ControlModel._();

  const factory ControlModel({
    required String id,
    required String title,
    required String subtitle,
    String? iconName,
    @Default(false) bool isOn,
  }) = _ControlModel;

  factory ControlModel.fromJson(Map<String, dynamic> json) => _$ControlModelFromJson(json);

  Control toEntity() {
    return Control(
      id: id,
      title: title,
      subtitle: subtitle,
      iconName: iconName,
      isOn: isOn,
    );
  }
}