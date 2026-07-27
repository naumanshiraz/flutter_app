import 'package:equatable/equatable.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';

/// Header info shown at the top of the Property Detail screen (hero
/// image, name, full address, and the Report/Invoice actions) — the
/// screen a user lands on from Home/Properties when they open a
/// specific property, e.g. "Gerlug Vista".
class PropertyDetail extends Equatable {
  final String id;
  final String name;
  final String address;
  final List<String> heroImageUrls;

  /// Which of the 3 "Available services" arrangements this property's
  /// screen should render — a single value from the API, not something
  /// computed client-side. See [ServicesGridLayout] for what each mode
  /// looks like.
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
