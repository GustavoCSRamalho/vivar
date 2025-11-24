import 'package:vivar/domain/interface/swipe/swipe_repository_protocol.dart';
import 'package:vivar/models/business_model.dart';
import 'package:vivar/models/place_model.dart';
import 'package:vivar/domain/entity/swipe/swipe_place_entity.dart';
import 'package:vivar/screens/swipe/data/datasource/swipe_sync_service.dart';

class SwipeRepositoryImpl implements SwipeRepositoryProtocol {
  final SwipeSyncService _syncService;

  SwipeRepositoryImpl({required SwipeSyncService syncService})
    : _syncService = syncService;

  @override
  Future<List<SwipePlaceEntity>> getSwipePlaces() async {
    try {
      // Busca do local através do sync service
      final localModels = await _syncService.getSwipePlaces();

      if (localModels.isNotEmpty) {
        print('✅ Lugares carregados do cache local');
        return localModels.map(_modelToEntity).toList();
      }

      // Se não tiver local, busca do remoto através do sync service
      print('🌐 Buscando lugares do servidor...');
      final remoteModels = await _syncService.getSwipePlacesRemote();

      return remoteModels.map(_modelToEntity).toList();
    } catch (e) {
      print('❌ Erro ao buscar lugares para swipe: $e');
      rethrow;
    }
  }

  @override
  Future<void> likePlace(String userId, String placeId) async {
    try {
      // Salva localmente através do sync service
      await _syncService.likePlace(userId, placeId);
      print('✅ Like salvo localmente');

      // Sincroniza em background (não espera)
      _syncService.syncToRemote(userId).catchError((e) {
        print('⚠️ Erro na sincronização automática: $e');
      });
    } catch (e) {
      print('❌ Erro ao dar like: $e');
      rethrow;
    }
  }

  @override
  Future<void> dislikePlace(String userId, String placeId) async {
    try {
      // Salva localmente através do sync service
      await _syncService.dislikePlace(userId, placeId);
      print('✅ Dislike salvo localmente');

      // Sincroniza em background (não espera)
      _syncService.syncToRemote(userId).catchError((e) {
        print('⚠️ Erro na sincronização automática: $e');
      });
    } catch (e) {
      print('❌ Erro ao dar dislike: $e');
      rethrow;
    }
  }

  @override
  Future<void> superLikePlace(String userId, String placeId) async {
    try {
      // Salva localmente através do sync service
      await _syncService.superLikePlace(userId, placeId);
      print('✅ Super like salvo localmente');

      // Sincroniza em background (não espera)
      _syncService.syncToRemote(userId).catchError((e) {
        print('⚠️ Erro na sincronização automática: $e');
      });
    } catch (e) {
      print('❌ Erro ao dar super like: $e');
      rethrow;
    }
  }

  /// Sincronização completa (bidirecional)
  /// Deve ser chamada ao abrir o app ou quando voltar online
  Future<void> sync(String userId) async {
    try {
      await _syncService.fullSync(userId);
    } catch (e) {
      print('❌ Erro na sincronização: $e');
      // Não propaga erro - app continua funcionando offline
    }
  }

  SwipePlaceEntity _modelToEntity(BusinessModel model) {
    final tags = <String>[];
    if (model.amenities != null) {
      tags.addAll(model.amenities!.take(3));
    }

    final distance = (model.distance ?? 0) / 1000;

    return SwipePlaceEntity(
      id: model.id,
      name: model.name,
      category: model.category,
      description: model.description ?? "Sem descrição",
      rating: model.rating,
      priceRange: model.priceRange ?? "\$\$",
      distance: distance,
      tags: tags,
      images: model.images,
      discount: model.discountText,
      isOpen: model.isOpen,
    );
  }
}
