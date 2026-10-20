import 'package:flutter/material.dart';
import 'package:pms_app/core/widgets/entity_summary_card.dart';
import 'package:pms_app/features/join_requests/domain/entities/join_request.dart';

String _capitalize(String v) => v.isEmpty ? '-' : v[0].toUpperCase() + v.substring(1).toLowerCase();

String _dash(String v) => v.isEmpty ? '-' : v;

class JoinRequestCard extends StatelessWidget {
  final JoinRequest request;
  final int index;
  final int total;

  const JoinRequestCard({super.key, required this.request, this.index = 0, this.total = 1});

  @override
  Widget build(BuildContext context) {
    final r = request;
    return EntitySummaryCard(
      itemLabel: 'Join request',
      index: index,
      total: total,
      showMenu: false,
      onAction: (_) {},
      rows: [
        [
          SummaryField(label: 'Name', value: _dash(r.requesterName)),
          SummaryField(label: 'Relationship', value: _capitalize(r.relation)),
          SummaryField(label: 'Status', value: _capitalize(r.status)),
        ],
        [
          SummaryField(label: 'Email', value: r.isEmail ? r.identifier : '-'),
          SummaryField(label: 'Phone', value: r.isEmail ? '-' : _dash(r.identifier)),
          const SummaryField(label: '', value: ''),
        ],
        [
          SummaryField(label: 'Development', value: _dash(r.developmentName), flex: 2),
          SummaryField(label: 'Building', value: _dash(r.buildingName)),
        ],
        [
          SummaryField(label: 'Suite', value: _dash(r.suite)),
          SummaryField(label: 'Floor', value: _dash(r.floor)),
          SummaryField(label: 'Type', value: _capitalize(r.unitType)),
        ],
      ],
    );
  }
}
