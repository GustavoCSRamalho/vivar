// presentation/providers/challenges_provider_factory.dart

import '../screens/challenges/data/repositories/challenges_repository_impl.dart';
import '../domain/usecases/challenges/complete_challenge_usecase.dart';
import '../domain/usecases/challenges/get_active_challenges_usecase.dart';
import '../domain/usecases/challenges/get_challenges_usecase.dart';
import '../domain/usecases/challenges/get_completed_challenges_usecase.dart';
import '../domain/usecases/challenges/update_challenge_progress_usecase.dart';
import '../screens/challenges/presentation/providers/challenges_provider.dart';

class ChallengesProviderFactory {
  static ChallengesProvider create() {
    final repository = ChallengesRepositoryImpl();

    final getChallengesUseCase = GetChallengesUseCase(repository);
    final getActiveChallengesUseCase = GetActiveChallengesUseCase(repository);
    final getCompletedChallengesUseCase = GetCompletedChallengesUseCase(
      repository,
    );
    final updateChallengeProgressUseCase = UpdateChallengeProgressUseCase(
      repository,
    );
    final completeChallengeUseCase = CompleteChallengeUseCase(repository);

    return ChallengesProvider(
      getChallengesUseCase: getChallengesUseCase,
      getActiveChallengesUseCase: getActiveChallengesUseCase,
      getCompletedChallengesUseCase: getCompletedChallengesUseCase,
      updateChallengeProgressUseCase: updateChallengeProgressUseCase,
      completeChallengeUseCase: completeChallengeUseCase,
    );
  }
}
