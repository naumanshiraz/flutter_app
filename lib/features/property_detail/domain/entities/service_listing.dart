import 'package:equatable/equatable.dart';

class ServiceListing extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  const ServiceListing({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl];
}

enum ServicesGridLayout { horizontal, vertical, grid }

ServicesGridLayout servicesGridLayoutFromApiValue(String? value) {
  switch (value) {
    case 'horizontal':
      return ServicesGridLayout.horizontal;
    case 'vertical':
      return ServicesGridLayout.vertical;
    case 'grid':
    default:
      return ServicesGridLayout.grid;
  }
}

String servicesGridLayoutToApiValue(ServicesGridLayout layout) {
  switch (layout) {
    case ServicesGridLayout.horizontal:
      return 'horizontal';
    case ServicesGridLayout.vertical:
      return 'vertical';
    case ServicesGridLayout.grid:
      return 'grid';
  }
}
