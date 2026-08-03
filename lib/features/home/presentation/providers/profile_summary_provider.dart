import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';
import 'package:pms_app/features/home/presentation/providers/home_di_providers.dart';

final profileSummaryProvider = FutureProvider.autoDispose<ProfileSummary>((ref) async {
  final useCase = ref.watch(getProfileSummaryUseCaseProvider);
  final result = await useCase();
  return result.when(
    onSuccess: (profile) => profile,
    onFailure: (failure) => throw Exception(failure.message),
  );
});
