import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/greetings/data/models/greeting_model.dart';

abstract class GreetingsRemoteDataSource {
  Future<List<GreetingModel>> getGreetings();
}

class GreetingsRemoteDataSourceImpl implements GreetingsRemoteDataSource {
  final Dio _dio;
  GreetingsRemoteDataSourceImpl(this._dio);

  static const List<Map<String, dynamic>> _mockGreetings = [
    {'id': 'greet-1', 'name': 'Narandelger Jargal'},
    {'id': 'greet-2', 'name': 'Dulamjav Jargal'},
  ];

  @override
  Future<List<GreetingModel>> getGreetings() async {
    try {
      // ---- MOCK (no backend yet) ------------------------------------
      await Future.delayed(const Duration(milliseconds: 400));
      return _mockGreetings.map(GreetingModel.fromJson).toList();

      // ---- REAL API (uncomment once the backend is live) -------------
      // final response = await _dio.get('/user/affiliates/greetings');
      // final data = response.data as List<dynamic>;
      // return data.map((j) => GreetingModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load greetings.');
    } catch (e) {
      throw ServerException('Unexpected error loading greetings: $e');
    }
  }
}
