import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/domain/entities/control.dart';

/// Domain contract for MainHome. Presentation depends only on this interface.
abstract class MainHomeRepository {
  /// Returns controls for [propertyId] (the property tapped on Home).
  /// Uses Result<T> to match app-wide error handling.
  Future<Result<List<Control>>> getControls({String? propertyId});

  /// Toggle a control; returns Result<void> for consistent error handling.
  Future<Result<void>> toggleControl(String id, bool newState);
}