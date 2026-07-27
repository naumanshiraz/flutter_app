import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/activity_log/data/models/log_entry_model.dart';

abstract class ActivityLogRemoteDataSource {
  Future<List<LogEntryModel>> getLogs();
}

class ActivityLogRemoteDataSourceImpl implements ActivityLogRemoteDataSource {
  final Dio _dio;
  ActivityLogRemoteDataSourceImpl(this._dio);

  static const List<Map<String, dynamic>> _mockLogs = [
    {'id': '1', 'title': 'Entrance Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Yesterday', 'kind': 'door', 'isMissed': true},
    {'id': '2', 'title': 'Front Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Yesterday', 'kind': 'call'},
    {'id': '3', 'title': 'South Campus Gate', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Tuesday'},
    {'id': '4', 'title': 'Entrance Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Tuesday', 'kind': 'door', 'isMissed': true},
    {'id': '5', 'title': 'Entrance Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Tuesday'},
    {'id': '6', 'title': 'Front Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Monday', 'kind': 'call', 'isMissed': true},
    {'id': '7', 'title': 'Lift Call', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Monday'},
    {'id': '8', 'title': 'Entrance Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Sunday', 'kind': 'door', 'isMissed': true},
    {'id': '9', 'title': 'Front Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Sunday', 'kind': 'call'},
    {'id': '10', 'title': 'North Campus Gate', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Sunday'},
    {'id': '11', 'title': 'Entrance Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Sunday', 'kind': 'door', 'isMissed': true},
    {'id': '12', 'title': 'Entrance Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Saturday'},
    {'id': '13', 'title': 'Front Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'Saturday', 'kind': 'door', 'isMissed': true},
    {'id': '14', 'title': 'Lift Call', 'location': 'Gerlug Vista, UB', 'dateLabel': 'June 20, 24'},
    {'id': '15', 'title': 'Entrance Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'June 20, 24'},
    {'id': '16', 'title': 'Front Door', 'location': 'Gerlug Vista, UB', 'dateLabel': 'June 20, 24', 'kind': 'door', 'isMissed': true},
  ];

  @override
  Future<List<LogEntryModel>> getLogs() async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      return _mockLogs.map(LogEntryModel.fromJson).toList();

      // final response = await _dio.get('/logs');
      // final data = response.data as List<dynamic>;
      // return data.map((j) => LogEntryModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch logs.');
    } catch (e) {
      throw ServerException('Unexpected error fetching logs: $e');
    }
  }
}
