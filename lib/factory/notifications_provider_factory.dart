// presentation/providers/notifications_provider_factory.dart

import 'package:vivar/domain/usecases/notifications/get_notifications_by_type_usecase.dart';
import '../../packages/home_module/lib/src/data/datasource/notification_datasource.dart';
import 'package:vivar/screens/notifications/data/datasource/notifications_datasource.dart';

import '../screens/notifications/data/repositories/notifications_repository_impl.dart';
import '../domain/usecases/notifications/delete_notification_usecase.dart';
import '../domain/usecases/notifications/get_notifications_usecase.dart';
import '../domain/usecases/notifications/get_unread_count_usecase.dart';
import '../domain/usecases/notifications/mark_all_as_read_usecase.dart';
import '../domain/usecases/notifications/mark_notification_as_read_usecase.dart';
import '../screens/notifications/presentation/providers/notifications_provider.dart';

class NotificationsProviderFactory {
  static NotificationsProvider create() {
    final datasource = NotificationsDatasource();
    final repository = NotificationsRepositoryImpl(datasource: datasource);

    final getNotificationsUseCase = GetNotificationsUseCase(repository);
    final getNotificationsByTypeUseCase = GetNotificationsByTypeUseCase(
      repository,
    );
    final markNotificationAsReadUseCase = MarkNotificationAsReadUseCase(
      repository,
    );
    final markAllAsReadUseCase = MarkAllAsReadUseCase(repository);
    final deleteNotificationUseCase = DeleteNotificationUseCase(repository);
    final getUnreadCountUseCase = GetUnreadCountUseCase(repository);

    return NotificationsProvider(
      getNotificationsUseCase: getNotificationsUseCase,
      getNotificationsByTypeUseCase: getNotificationsByTypeUseCase,
      markNotificationAsReadUseCase: markNotificationAsReadUseCase,
      markAllAsReadUseCase: markAllAsReadUseCase,
      deleteNotificationUseCase: deleteNotificationUseCase,
      getUnreadCountUseCase: getUnreadCountUseCase,
    );
  }
}
