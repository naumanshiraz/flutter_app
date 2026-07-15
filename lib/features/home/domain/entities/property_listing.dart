import 'package:equatable/equatable.dart';

/// A single property card shown in the Home grid.
class PropertyListing extends Equatable {
  final String id;
  final String title;
  final String managementCompany;
  final String imageUrl;

  const PropertyListing({
    required this.id,
    required this.title,
    required this.managementCompany,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, managementCompany, imageUrl];
}
