import 'package:equatable/equatable.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';

class ConciergeServiceItem extends Equatable {
  final ServiceListing service;
  final bool isBanner;

  const ConciergeServiceItem({required this.service, this.isBanner = false});

  @override
  List<Object?> get props => [service, isBanner];
}
