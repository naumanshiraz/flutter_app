import 'package:equatable/equatable.dart';

/// Entity for a single control shown on the MainHome screen.
class Control extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String? iconName;
  final bool isOn;

  const Control({
    required this.id,
    required this.title,
    required this.subtitle,
    this.iconName,
    required this.isOn,
  });

  Control copyWith({bool? isOn}) {
    return Control(
      id: id,
      title: title,
      subtitle: subtitle,
      iconName: iconName,
      isOn: isOn ?? this.isOn,
    );
  }

  @override
  List<Object?> get props => [id, title, subtitle, iconName, isOn];
}