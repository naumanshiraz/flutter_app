import 'package:flutter/material.dart';
import 'package:pms_app/core/widgets/entity_summary_card.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';

typedef VehicleCardAction = EntitySummaryCardAction;

/// Matches the design's summary card: License plate number/Brand on
/// one row, Type/Engine type on the next, inside a grey card — with
/// "Vehicle X of N" and the Edit/Delete overflow menu on their own row
/// below the card.
class VehicleSummaryCard extends StatelessWidget {
  final Vehicle vehicle;
  final int index;
  final int total;
  final ValueChanged<VehicleCardAction> onAction;

  const VehicleSummaryCard({
    super.key,
    required this.vehicle,
    required this.index,
    required this.total,
    required this.onAction,
  });

  /// The design shows "7586 - УБР" on the card even though the field
  /// itself holds "7586 УБР" — insert the dash for display only.
  String get _formattedPlate {
    final raw = vehicle.licensePlate.trim();
    final spaceIndex = raw.indexOf(' ');
    if (spaceIndex == -1) return raw;
    return '${raw.substring(0, spaceIndex)} - ${raw.substring(spaceIndex + 1)}';
  }

  @override
  Widget build(BuildContext context) {
    return EntitySummaryCard(
      itemLabel: 'Vehicle',
      index: index,
      total: total,
      onAction: onAction,
      rows: [
        [
          SummaryField(label: 'License plate number', value: _formattedPlate),
          SummaryField(label: 'Brand', value: vehicle.brand ?? '-'),
        ],
        [
          SummaryField(label: 'Type', value: vehicle.type ?? '-'),
          SummaryField(label: 'Engine type', value: vehicle.engineType ?? '-'),
        ],
      ],
    );
  }
}
