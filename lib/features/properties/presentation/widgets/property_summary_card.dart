import 'package:flutter/material.dart';
import 'package:pms_app/core/widgets/entity_summary_card.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/presentation/widgets/property_options.dart';

typedef PropertyCardAction = EntitySummaryCardAction;

/// Matches the design's summary card: Suite/Floor/Residency on one
/// row, Building/Type/Place on the next, inside a grey card — with
/// "Property X of N" and the Edit/Delete overflow menu on their own
/// row *below* the card (Residency + Place come from the Residency
/// Identification step, not this form).
class PropertySummaryCard extends StatelessWidget {
  final Property property;
  final int index;
  final int total;
  final String residencyName;
  final String place;
  final ValueChanged<PropertyCardAction> onAction;

  const PropertySummaryCard({
    super.key,
    required this.property,
    required this.index,
    required this.total,
    required this.residencyName,
    required this.place,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final floorDisplay = property.floor == null ? '-' : PropertyOptions.ordinal(property.floor!);

    return EntitySummaryCard(
      itemLabel: 'Property',
      index: index,
      total: total,
      onAction: onAction,
      rows: [
        [
          SummaryField(label: 'Suite', value: '# ${property.suite}'),
          SummaryField(label: 'Floor', value: floorDisplay),
          SummaryField(label: 'Residency', value: residencyName.isEmpty ? '-' : residencyName),
        ],
        [
          SummaryField(label: 'Building', value: property.building ?? '-'),
          SummaryField(label: 'Type', value: property.type ?? '-'),
          SummaryField(label: 'Place', value: place.isEmpty ? '-' : place, flex: 2),
        ],
      ],
    );
  }
}
