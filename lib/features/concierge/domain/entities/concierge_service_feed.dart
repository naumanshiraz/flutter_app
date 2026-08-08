import 'package:equatable/equatable.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_grid_layout.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_service_item.dart';

class ConciergeServiceFeed extends Equatable {
  final List<ConciergeServiceItem> items;
  final ConciergeGridLayout layout;

  const ConciergeServiceFeed({required this.items, required this.layout});

  @override
  List<Object?> get props => [items, layout];
}
