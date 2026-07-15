import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';

/// Domain contract for the property list — full CRUD, since this
/// screen explicitly needs add/edit/delete, same pattern as
/// `FamilyMembersRepository`.
abstract class PropertiesRepository {
  Future<Result<List<Property>>> getProperties();
  Future<Result<void>> addProperty(Property property);
  Future<Result<void>> updateProperty(Property property);
  Future<Result<void>> deleteProperty(String id);
}
