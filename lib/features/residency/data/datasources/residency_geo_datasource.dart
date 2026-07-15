/// **There is no geo/places backend yet.** This is a small hand-built
/// mock of the address hierarchy shown in the design (Mongolia /
/// Ulaanbaatar / Khan Uul / 15th khoroo / Gerlug Vista), deep enough to
/// demonstrate real cascading-selection behavior. Every other country
/// falls back to a single generic entry per level.
///
/// To go live: replace this whole class with a real
/// `ResidencyRemoteDataSource` that calls a geo/places API — the
/// [ResidencyFormNotifier] that consumes this only calls plain
/// synchronous methods, so the swap is a small, contained change; wrap
/// these calls in `Future`s at that point if the real API is async.
abstract class ResidencyGeoDataSource {
  List<String> countries();
  List<String> citiesFor(String country);
  List<String> districtsFor(String city);
  List<String> khoroosFor(String district);
  List<String> residencesFor(String khoroo);
}

class ResidencyGeoDataSourceImpl implements ResidencyGeoDataSource {
  static const List<String> _countries = [
    'Mongolia',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Pakistan',
    'United Arab Emirates',
  ];

  static const Map<String, List<String>> _citiesByCountry = {
    'Mongolia': ['Ulaanbaatar', 'Erdenet', 'Darkhan'],
  };

  static const Map<String, List<String>> _districtsByCity = {
    'Ulaanbaatar': ['Khan Uul', 'Bayanzurkh', 'Sukhbaatar', 'Chingeltei'],
  };

  static const Map<String, List<String>> _khoroosByDistrict = {
    'Khan Uul': ['15th khoroo', '16th khoroo', '3rd khoroo'],
    'Bayanzurkh': ['1st khoroo', '2nd khoroo'],
  };

  static const Map<String, List<String>> _residencesByKhoroo = {
    '15th khoroo': ['Gerlug Vista', 'Skyline Residence', 'River Park Towers'],
    '16th khoroo': ['Sunrise Apartments', 'Central Plaza'],
  };

  static const List<String> _fallback = ['Not specified'];

  @override
  List<String> countries() => _countries;

  @override
  List<String> citiesFor(String country) => _citiesByCountry[country] ?? _fallback;

  @override
  List<String> districtsFor(String city) => _districtsByCity[city] ?? _fallback;

  @override
  List<String> khoroosFor(String district) => _khoroosByDistrict[district] ?? _fallback;

  @override
  List<String> residencesFor(String khoroo) => _residencesByKhoroo[khoroo] ?? _fallback;
}
