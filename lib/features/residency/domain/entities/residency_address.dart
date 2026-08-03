import 'package:equatable/equatable.dart';

class ResidencyAddress extends Equatable {
  final String? country;
  final String? city;
  final String? district;
  final String? khoroo;
  final String? residence;

  const ResidencyAddress({
    this.country,
    this.city,
    this.district,
    this.khoroo,
    this.residence,
  });

  bool get isComplete =>
      country != null && city != null && district != null && khoroo != null && residence != null;

  ResidencyAddress copyWith({
    String? country,
    String? city,
    String? district,
    String? khoroo,
    String? residence,
  }) {
    return ResidencyAddress(
      country: country ?? this.country,
      city: city ?? this.city,
      district: district ?? this.district,
      khoroo: khoroo ?? this.khoroo,
      residence: residence ?? this.residence,
    );
  }

  /// Clears every level *below* [level] — called whenever a higher-level
  /// selection changes, since a new Country/City/etc invalidates
  /// whatever was chosen underneath it.
  ResidencyAddress clearBelow(ResidencyLevel level) {
    switch (level) {
      case ResidencyLevel.country:
        return ResidencyAddress(country: country);
      case ResidencyLevel.city:
        return ResidencyAddress(country: country, city: city);
      case ResidencyLevel.district:
        return ResidencyAddress(country: country, city: city, district: district);
      case ResidencyLevel.khoroo:
        return ResidencyAddress(country: country, city: city, district: district, khoroo: khoroo);
      case ResidencyLevel.residence:
        return this;
    }
  }

  @override
  List<Object?> get props => [country, city, district, khoroo, residence];
}

enum ResidencyLevel { country, city, district, khoroo, residence }
