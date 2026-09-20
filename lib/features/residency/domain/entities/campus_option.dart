import 'package:equatable/equatable.dart';

/// A row from `GET /api/app/campuses`, for the "Campuses or project"
/// dropdown.
class CampusOption extends Equatable {
  final String id;
  final String name;

  const CampusOption({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
