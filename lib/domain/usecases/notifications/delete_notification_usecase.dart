// // domain/usecases/notifications/delete_notification_usecase.dart

// import '../../interface/notification/notifications_repository_protocol.dart';

// class DeleteNotificationUseCase {
//   final NotificationsRepositoryProtocol _repository;

//   DeleteNotificationUseCase(this._repository);

//   Future<void> execute(String notificationId, String userId) async {
//     if (notificationId.trim().isEmpty) {
//       throw Exception('ID da notificação é obrigatório');
//     }

//     if (userId.trim().isEmpty) {
//       throw Exception('ID do usuário é obrigatório');
//     }

//     try {
//       await _repository.deleteNotification(notificationId, userId);
//     } catch (e) {
//       print('❌ Erro ao deletar notificação: $e');
//       rethrow;
//     }
//   }
// }
