// // domain/usecases/notification/mark_notification_as_read_usecase.dart

// import '../../../../packages/home_module/lib/src/domain/interfaces/notification_repository_protocol.dart';

// class MarkNotificationAsReadUseCase {
//   final NotificationRepositoryProtocol _notificationRepository;

//   MarkNotificationAsReadUseCase(this._notificationRepository);

//   Future<void> execute(String notificationId) async {
//     try {
//       if (notificationId.trim().isEmpty) {
//         throw Exception('Notification ID não pode ser vazio');
//       }

//       await _notificationRepository.markAsRead(notificationId);
//     } catch (e) {
//       print('❌ Erro ao marcar notificação como lida: $e');
//       rethrow;
//     }
//   }
// }
