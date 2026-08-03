import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/family_members/data/models/family_member_model.dart';

abstract class FamilyMembersRemoteDataSource {
  Future<void> addMember(FamilyMemberModel member);
  Future<void> updateMember(FamilyMemberModel member);
  Future<void> deleteMember(String id);
}

class FamilyMembersRemoteDataSourceImpl implements FamilyMembersRemoteDataSource {
  final Dio _dio;

  FamilyMembersRemoteDataSourceImpl(this._dio);

  @override
  Future<void> addMember(FamilyMemberModel member) async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 500));

      // ---- REAL API (uncomment once the backend exists) ---------------
      // await _dio.post('/user/family-members', data: member.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to add family member.');
    } catch (e) {
      throw ServerException('Unexpected error adding family member: $e');
    }
  }

  @override
  Future<void> updateMember(FamilyMemberModel member) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // await _dio.patch('/user/family-members/${member.id}', data: member.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to update family member.');
    } catch (e) {
      throw ServerException('Unexpected error updating family member: $e');
    }
  }

  @override
  Future<void> deleteMember(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      // await _dio.delete('/user/family-members/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete family member.');
    } catch (e) {
      throw ServerException('Unexpected error deleting family member: $e');
    }
  }
}
