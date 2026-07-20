/// Static picker options for the vehicle form. No backend for this
/// yet, so these are hand-picked common values — swap for a real
/// vehicle-data lookup once one exists.
class VehicleOptions {
  VehicleOptions._();

  static const List<String> types = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Truck',
    'Van',
    'Motorcycle',
    'Other',
  ];

  static const List<String> brands = [
    'Toyota',
    'Honda',
    'Hyundai',
    'Kia',
    'Nissan',
    'Ford',
    'Volkswagen',
    'Other',
  ];

  static const List<String> engineTypes = ['Petrol', 'Diesel', 'Hybrid', 'Electric'];
}
