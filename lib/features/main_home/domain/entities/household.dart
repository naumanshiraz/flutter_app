import 'package:equatable/equatable.dart';

class Household extends Equatable {
  final String id;
  final String suite;
  final int floor;
  final String unitType;
  final bool claimed;
  final String buildingId;
  final String buildingName;
  final String? imageUrl;
  final double? area;
  final String? unitOfMeasure;
  final String? city;
  final String? country;

  const Household({
    required this.id,
    required this.suite,
    required this.floor,
    required this.unitType,
    required this.claimed,
    required this.buildingId,
    required this.buildingName,
    this.imageUrl,
    this.area,
    this.unitOfMeasure,
    this.city,
    this.country,
  });

  String get displayName => buildingName;

  String get displaySubtitle {
    final parts = <String>['Suite $suite', 'Floor $floor', unitType];
    if (area != null && area! > 0) {
      parts.add('${area!.toStringAsFixed(0)} ${unitOfMeasure ?? 'sqm'}');
    }
    return parts.join(' • ');
  }

  String? get displayAddress {
    final parts = [city, country].where((p) => p != null && p.trim().isNotEmpty).toList();
    return parts.isEmpty ? null : parts.join(', ');
  }

  @override
  List<Object?> get props =>
      [id, suite, floor, unitType, claimed, buildingId, buildingName, imageUrl, area, unitOfMeasure, city, country];
}
