import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/bank_transaction/data/datasources/bank_transaction_remote_datasource.dart';
import 'package:pms_app/features/bank_transaction/data/repositories/bank_transaction_repository_impl.dart';
import 'package:pms_app/features/bank_transaction/domain/repositories/bank_transaction_repository.dart';
import 'package:pms_app/features/bank_transaction/domain/usecases/get_bank_transaction_detail_usecase.dart';

final bankTransactionRemoteDataSourceProvider = Provider<BankTransactionRemoteDataSource>((ref) {
  return BankTransactionRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final bankTransactionRepositoryProvider = Provider<BankTransactionRepository>((ref) {
  return BankTransactionRepositoryImpl(remoteDataSource: ref.watch(bankTransactionRemoteDataSourceProvider));
});

final getBankTransactionDetailUseCaseProvider = Provider<GetBankTransactionDetailUseCase>((ref) {
  return GetBankTransactionDetailUseCase(ref.watch(bankTransactionRepositoryProvider));
});
