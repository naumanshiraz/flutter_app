import 'package:equatable/equatable.dart';

class Greeting extends Equatable {
  final String id;
  final String name;

  const Greeting({required this.id, required this.name});

  String get label => "$name's greetings";

  @override
  List<Object?> get props => [id, name];
}
