import 'package:equatable/equatable.dart';

class ResidencyAddress extends Equatable {
  final String? campusId;
  final String? campusName;
  final String? country;
  final String? city;

  const ResidencyAddress({
    this.campusId,
    this.campusName,
    this.country,
    this.city,
  });

  bool get isComplete => campusId != null && country != null && city != null;

  ResidencyAddress copyWith({
    String? campusId,
    String? campusName,
    String? country,
    String? city,
  }) {
    return ResidencyAddress(
      campusId: campusId ?? this.campusId,
      campusName: campusName ?? this.campusName,
      country: country ?? this.country,
      city: city ?? this.city,
    );
  }

  /// Clears City whenever Country changes — a new country invalidates
  /// whatever city was chosen under the old one. Campus is independent
  /// of Country/City, so it's never cleared by this.
  ResidencyAddress clearBelow(ResidencyLevel level) {
    switch (level) {
      case ResidencyLevel.campus:
        return this;
      case ResidencyLevel.country:
        return ResidencyAddress(campusId: campusId, campusName: campusName, country: country);
      case ResidencyLevel.city:
        return this;
    }
  }

  @override
  List<Object?> get props => [campusId, campusName, country, city];
}

enum ResidencyLevel { campus, country, city }
