import 'package:vivar/domain/interface/swipe/swipe_repository_protocol.dart';
import 'package:vivar/models/place_model.dart';
import 'package:vivar/domain/entity/swipe/swipe_place_entity.dart';
import 'package:vivar/screens/swipe/data/datasource/swipe_local_datasource.dart';

class SwipeRepositoryImpl implements SwipeRepositoryProtocol {
  final SwipeLocalDataSourceProtocol datasource;

  SwipeRepositoryImpl({required this.datasource});

  @override
  Future<List<SwipePlaceEntity>> getSwipePlaces() async {
    final models = await datasource.getSwipePlaces();
    return models.map(_modelToEntity).toList();
  }

  @override
  Future<void> likePlace(String userId, String placeId) {
    return datasource.likePlace(userId, placeId);
  }

  @override
  Future<void> dislikePlace(String userId, String placeId) {
    return datasource.dislikePlace(userId, placeId);
  }

  @override
  Future<void> superLikePlace(String userId, String placeId) {
    return datasource.superLikePlace(userId, placeId);
  }

  SwipePlaceEntity _modelToEntity(PlaceModel model) {
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
