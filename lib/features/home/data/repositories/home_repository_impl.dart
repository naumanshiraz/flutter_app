import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/home/data/datasources/home_local_datasource.dart';
import 'package:pms_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';
import 'package:pms_app/features/home/domain/entities/property_listing.dart';
import 'package:pms_app/features/home/domain/repositories/home_repository.dart';

const ProfileSummary _kDemoProfile = ProfileSummary(
  name: 'Narandelger Dashdorj',
  email: 'naradee@gmail.com',
  phone: '+976 9999 8888',
);

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource _localDataSource;
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({
    required HomeLocalDataSource localDataSource,
    required HomeRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<ProfileSummary>> getProfileSummary() async {
    try {
      final cached = _localDataSource.getCachedProfile();
      return Success(cached?.toEntity() ?? _kDemoProfile);
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load profile: $e'));
    }
  }

  @override
  Future<Result<List<PropertyListing>>> getPropertyListings({String? searchQuery}) async {
    try {
      final models = await _remoteDataSource.getPropertyListings();
      var listings = models.map((m) => m.toEntity()).toList();

      final query = searchQuery?.trim().toLowerCase();
      if (query != null && query.isNotEmpty) {
        listings = listings
            .where((l) =>
                l.title.toLowerCase().contains(query) ||
                l.managementCompany.toLowerCase().contains(query),)
            .toList();
      }

      return Success(listings);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load property listings: $e'));
    }
  }
}
