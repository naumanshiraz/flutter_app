import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';

abstract class ConciergeRemoteDataSource {
  Future<Map<String, dynamic>> getServices(String category);
}

class ConciergeRemoteDataSourceImpl implements ConciergeRemoteDataSource {
  final Dio _dio;

  ConciergeRemoteDataSourceImpl(this._dio);

  static const List<Map<String, dynamic>> _forYou = [
    {
      'id': 'burj_khalifa_1',
      'name': 'Burj Khalifa',
      'description': 'Mahmud Management Group',
      'imageUrl': 'https://picsum.photos/seed/burjkhalifa1/700/700',
      'isBanner': false,
    },
    {
      'id': 'burj_khalifa_2',
      'name': 'Burj Khalifa',
      'description': 'Mahmud Management Group',
      'imageUrl': 'https://picsum.photos/seed/burjkhalifa2/700/500',
      'isBanner': false,
    },
    {
      'id': 'california_bakery',
      'name': 'California bakery',
      'description': 'Japanese style cake house',
      'imageUrl': 'https://picsum.photos/seed/californiabakery/700/500',
      'isBanner': false,
    },
    {
      'id': 'sears_tower',
      'name': 'Sears Tower',
      'description': 'Fusion property',
      'imageUrl': 'https://picsum.photos/seed/searstower/700/700',
      'isBanner': false,
    },
    {
      'id': 'light_house',
      'name': 'Light House',
      'description': 'Jordan Light House',
      'imageUrl': 'https://picsum.photos/seed/lighthouse/700/700',
      'isBanner': false,
    },
    {
      'id': 'house_printing_service',
      'name': 'House printing service',
      'description': 'High quality photo sticker printing and 3D printing',
      'imageUrl': 'https://picsum.photos/seed/houseprinting/700/400',
      'isBanner': true,
    },
    {
      'id': 'linen_service',
      'name': 'Linen service',
      'description': 'Fresh linens delivered weekly',
      'imageUrl': 'https://picsum.photos/seed/linenservice/700/700',
      'isBanner': false,
    },
    {
      'id': 'fireplace_lounge',
      'name': 'Fireplace lounge',
      'description': 'Book the residents lounge',
      'imageUrl': 'https://picsum.photos/seed/fireplacelounge/700/700',
      'isBanner': false,
    },
  ];

  static const List<Map<String, dynamic>> _food = [
    {
      'id': 'california_bakery',
      'name': 'California bakery',
      'description': 'Japanese style cake house',
      'imageUrl': 'https://picsum.photos/seed/californiabakery/700/500',
      'isBanner': false,
    },
    {
      'id': 'house_printing_service',
      'name': 'House printing service',
      'description': 'High quality photo sticker printing and 3D printing',
      'imageUrl': 'https://picsum.photos/seed/houseprinting/700/400',
      'isBanner': true,
    },
  ];

  static const List<Map<String, dynamic>> _cleaning = [
    {
      'id': 'linen_service',
      'name': 'Linen service',
      'description': 'Fresh linens delivered weekly',
      'imageUrl': 'https://picsum.photos/seed/linenservice/700/700',
      'isBanner': false,
    },
  ];

  static const List<Map<String, dynamic>> _delivery = [
    {
      'id': 'burj_khalifa_1',
      'name': 'Burj Khalifa',
      'description': 'Mahmud Management Group',
      'imageUrl': 'https://picsum.photos/seed/burjkhalifa1/700/700',
      'isBanner': false,
    },
  ];

  @override
  Future<Map<String, dynamic>> getServices(String category) async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 500));
      final (layout, json) = switch (category) {
        'food' => ('verticalRight', _food),
        'cleaningService' => ('grid', _cleaning),
        'delivery' => ('grid', _delivery),
        _ => ('verticalRight', _forYou),
      };
      return {'layout': layout, 'services': json};

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.get(
      //   AppConstants.endpointConciergeServices,
      //   queryParameters: {'category': category},
      // );
      // return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load services.');
    } catch (e) {
      throw ServerException('Unexpected error loading services: $e');
    }
  }
}
