import 'package:equatable/equatable.dart';

/// A single entry under "Available services" on the Property Detail
/// screen (e.g. "Printing house", "California bakery"). How this tile
/// is *arranged* on screen is not a property of the item itself — see
/// [ServicesGridLayout] — it's a single screen-level setting the API
/// returns, so the whole grid re-arranges together.
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

/// Which of the 3 "Available services" grid arrangements to render —
/// matches "Detailed view - 01/02/03" in the design exactly. This is a
/// **single, screen-level** value returned by the API alongside the
/// property detail (see `PropertyDetail.servicesLayout`); the app never
/// decides this on-device — flipping the API's field is what switches
/// the whole screen between the 3 designs.
///
///  - [horizontal] -> view 01: first service is a full-width banner,
///    every service after it sits in a plain 2-column grid.
///  - [vertical]   -> view 02: first service is a tall portrait tile on
///    the left, the next two services stack normally on the right,
///    every service after that sits in a plain 2-column grid.
///  - [grid]       -> view 03: every service sits in a plain 2-column
///    grid, all tiles the same square-ish size.
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
