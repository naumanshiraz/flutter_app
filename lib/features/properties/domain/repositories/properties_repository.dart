import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/properties/domain/entities/available_suite.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';

abstract class PropertiesRepository {
  Future<Result<List<AvailableSuite>>> getAvailableSuites(String campusId);
  Future<Result<void>> submitClaimRequest(String householdId);
  Future<Result<void>> updateProperty(Property property);
  Future<Result<void>> deleteProperty(String id);
}
