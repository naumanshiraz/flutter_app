import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/greetings/domain/entities/greeting.dart';
import 'package:pms_app/features/greetings/presentation/providers/greetings_di_providers.dart';

class GreetingsState {
  final bool isLoading;
  final List<Greeting> greetings;
  final String? errorMessage;

  const GreetingsState({this.isLoading = true, this.greetings = const [], this.errorMessage});

  GreetingsState copyWith({bool? isLoading, List<Greeting>? greetings, String? errorMessage}) {
    return GreetingsState(
      isLoading: isLoading ?? this.isLoading,
      greetings: greetings ?? this.greetings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class GreetingsNotifier extends StateNotifier<GreetingsState> {
  final Ref _ref;
  GreetingsNotifier(this._ref) : super(const GreetingsState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    final useCase = _ref.read(getGreetingsUseCaseProvider);
    final result = await useCase();
    result.when(
      onSuccess: (greetings) => state = state.copyWith(isLoading: false, greetings: greetings),
      onFailure: (f) => state = state.copyWith(isLoading: false, errorMessage: f.message),
    );
  }

  Future<void> refresh() => _load();
}

final greetingsProvider = StateNotifierProvider.autoDispose<GreetingsNotifier, GreetingsState>(
  (ref) => GreetingsNotifier(ref),
);
