import 'package:equatable/equatable.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';

class PropertyDetail extends Equatable {
  final String id;
  final String name;
  final String address;
  final List<String> heroImageUrls;
  final ServicesGridLayout servicesLayout;

  const PropertyDetail({
    required this.id,
    required this.name,
    required this.address,
    this.heroImageUrls = const [],
    this.servicesLayout = ServicesGridLayout.grid,
  });

  @override
  List<Object?> get props => [id, name, address, heroImageUrls, servicesLayout];
}
