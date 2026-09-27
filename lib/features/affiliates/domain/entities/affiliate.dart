import 'package:equatable/equatable.dart';

/// A person affiliated with a household (occupant, tenant, family member).
/// Shared by all three affiliate surfaces:
///  - Onboarding "Please identify your affiliates" step — added without a
///    [householdId] (the household doesn't exist yet at that point).
///  - "Occupants" on the property detail's Residential information sheet —
///    added with the current [householdId].
///  - "Affiliates management" in Account management (all households) —
///    added without a [householdId] filter (shows/adds across all of them).
///
/// Status flow: every newly added affiliate starts as 'Pending' (a
/// "greeting" — see [addedByName]) until the person who added them reviews
/// and Accepts it (-> 'Engaged') or Declines it (record is deleted, not
/// kept as a rejected status).
class Affiliate extends Equatable {
  static const String statusPending = 'Pending';
  static const String statusEngaged = 'Engaged';

  final String id;
  final String? householdId;
  final String name;
  final String email;
  final String phone;
  final String? relationship;
  final String status;
  final String addedByName;

  const Affiliate({
    required this.id,
    this.householdId,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.relationship,
    this.status = statusPending,
    this.addedByName = '',
  });

  bool get isTenant => relationship == 'Tenant';

  bool get isPending => status == statusPending;

  Affiliate copyWith({
    String? householdId,
    String? name,
    String? email,
    String? phone,
    String? relationship,
    String? status,
    String? addedByName,
  }) {
    return Affiliate(
      id: id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      status: status ?? this.status,
      addedByName: addedByName ?? this.addedByName,
    );
  }

  @override
  List<Object?> get props => [id, householdId, name, email, phone, relationship, status, addedByName];
}
