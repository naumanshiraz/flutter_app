import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/greetings/domain/entities/greeting.dart';

part 'greeting_model.freezed.dart';
part 'greeting_model.g.dart';

@freezed
class GreetingModel with _$GreetingModel {
  const GreetingModel._();

  const factory GreetingModel({
    required String id,
    required String name,
  }) = _GreetingModel;

  factory GreetingModel.fromJson(Map<String, dynamic> json) => _$GreetingModelFromJson(json);

  Greeting toEntity() => Greeting(id: id, name: name);
}
