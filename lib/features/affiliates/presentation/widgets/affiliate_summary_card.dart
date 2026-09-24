import 'package:flutter/material.dart';
import 'package:pms_app/core/widgets/entity_summary_card.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';

typedef AffiliateCardAction = EntitySummaryCardAction;

class AffiliateSummaryCard extends StatelessWidget {
  final Affiliate affiliate;
  final String itemLabel;
  final int index;
  final int total;
  final ValueChanged<AffiliateCardAction> onAction;

  const AffiliateSummaryCard({
    super.key,
    required this.affiliate,
    required this.index,
    required this.total,
    required this.onAction,
    this.itemLabel = 'Family member',
  });

  @override
  Widget build(BuildContext context) {
    return EntitySummaryCard(
      itemLabel: affiliate.isTenant ? 'Tenant' : itemLabel,
      index: index,
      total: total,
      onAction: onAction,
      rows: [
        [
          SummaryField(label: 'Name', value: affiliate.name.isEmpty ? '-' : affiliate.name),
          SummaryField(label: 'Relationship', value: affiliate.relationship ?? '-'),
          SummaryField(label: 'Status', value: affiliate.status),
        ],
        [
          SummaryField(label: 'Email', value: affiliate.email.isEmpty ? '-' : affiliate.email),
          SummaryField(label: 'Phone', value: affiliate.phone.isEmpty ? '-' : affiliate.phone),
          const SummaryField(label: '', value: ''),
        ],
      ],
    );
  }
}
