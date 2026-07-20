import 'package:flutter/material.dart';
import 'package:pms_app/core/widgets/entity_summary_card.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';

// Re-exported so pages that switch on the action don't need to import
// the core widget directly, and so this file's public surface hasn't
// changed shape for existing callers.
typedef FamilyMemberCardAction = EntitySummaryCardAction;

/// Matches the design's summary card: Name/Relationship/Year of birth
/// on one row, Email/Phone/Gender on the next, inside a grey card —
/// with "Family member X of N" and the Edit/Delete overflow menu on
/// their own row *below* the card (not inside it).
class FamilyMemberSummaryCard extends StatelessWidget {
  final FamilyMember member;
  final int index;
  final int total;
  final ValueChanged<FamilyMemberCardAction> onAction;

  const FamilyMemberSummaryCard({
    super.key,
    required this.member,
    required this.index,
    required this.total,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return EntitySummaryCard(
      itemLabel: 'Family member',
      index: index,
      total: total,
      onAction: onAction,
      rows: [
        [
          SummaryField(label: 'Name', value: member.name, flex: 2),
          SummaryField(label: 'Relationship', value: member.relationship ?? '-'),
          SummaryField(label: 'Year of birth', value: member.birthYear?.toString() ?? '-'),
        ],
        [
          SummaryField(label: 'Email', value: member.email, flex: 2),
          SummaryField(label: 'Phone', value: member.phone),
          SummaryField(label: 'Gender', value: member.gender ?? '-'),
        ],
      ],
    );
  }
}
