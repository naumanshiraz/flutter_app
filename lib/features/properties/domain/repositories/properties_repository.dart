import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';

abstract class PropertiesRepository {
  Future<Result<List<Property>>> getProperties();
  Future<Result<void>> addProperty(Property property);
  Future<Result<void>> updateProperty(Property property);
  Future<Result<void>> deleteProperty(String id);
}
