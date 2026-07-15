import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/data/datasources/family_members_local_datasource.dart';
import 'package:pms_app/features/family_members/data/datasources/family_members_remote_datasource.dart';
import 'package:pms_app/features/family_members/data/models/family_member_model.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';
import 'package:pms_app/features/family_members/domain/repositories/family_members_repository.dart';

class FamilyMembersRepositoryImpl implements FamilyMembersRepository {
  final FamilyMembersLocalDataSource _localDataSource;
  final FamilyMembersRemoteDataSource _remoteDataSource;

  FamilyMembersRepositoryImpl({
    required FamilyMembersLocalDataSource localDataSource,
    required FamilyMembersRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<FamilyMember>>> getMembers() async {
    try {
      final models = _localDataSource.getMembers();
      return Success(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load family members: $e'));
    }
  }

  @override
  Future<Result<void>> addMember(FamilyMember member) async {
    try {
      final model = FamilyMemberModel.fromEntity(member);
      await _remoteDataSource.addMember(model);

      final current = _localDataSource.getMembers();
      await _localDataSource.saveMembers([...current, model]);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to add family member: $e'));
    }
  }

  @override
  Future<Result<void>> updateMember(FamilyMember member) async {
    try {
      final model = FamilyMemberModel.fromEntity(member);
      await _remoteDataSource.updateMember(model);

      final current = _localDataSource.getMembers();
      final updated = current.map((m) => m.id == model.id ? model : m).toList();
      await _localDataSource.saveMembers(updated);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to update family member: $e'));
    }
  }

  @override
  Future<Result<void>> deleteMember(String id) async {
    try {
      await _remoteDataSource.deleteMember(id);

      final current = _localDataSource.getMembers();
      final updated = current.where((m) => m.id != id).toList();
      await _localDataSource.saveMembers(updated);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to delete family member: $e'));
    }
  }
}
