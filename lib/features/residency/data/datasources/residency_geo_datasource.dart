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
