// screens/notifications/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivar/core/constants/colors.dart';
import 'package:vivar/core/constants/text_styles.dart';
import 'package:vivar/core/constants/spacing.dart';

import '../../auth/presentation/login/login_provider.dart';
import 'providers/notifications_provider.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  Future<void> _loadNotifications() async {
    final user = context.read<LoginProvider>().currentUser;
    if (user != null) {
      await context.read<NotificationsProvider>().loadNotifications(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Notificações'),
        actions: [
          Consumer<NotificationsProvider>(
            builder: (context, provider, child) {
              if (provider.hasUnread) {
                return TextButton(
                  onPressed: _markAllAsRead,
                  child: Text('Marcar todas como lidas'),
                );
              }
              return SizedBox.shrink();
            },
          ),
          IconButton(icon: Icon(Icons.settings_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: Consumer<NotificationsProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.notifications.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final notifications = _getFilteredNotifications(provider);

                if (notifications.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(notifications[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Todas', 'Ofertas', 'Check-ins', 'Social', 'Sistema'];

    return Container(
      height: 48,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedTab == index;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tabs[index],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(notification) {
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => _deleteNotification(notification.id),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.horizontalPadding,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: isUnread ? Colors.white : AppColors.inputBackground,
          border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
        ),
        child: ListTile(
          leading: _buildNotificationIcon(notification.type),
          title: Text(
            notification.title,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                notification.message,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _formatTime(notification.createdAt),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          trailing: isUnread
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () => _handleNotificationTap(notification),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    IconData icon;
    Color backgroundColor;
    Color iconColor;

    switch (type) {
      case 'offer':
        icon = Icons.local_offer;
        backgroundColor = Color(0xFFFFF4E6);
        iconColor = AppColors.primary;
        break;
      case 'checkin':
        icon = Icons.location_on;
        backgroundColor = Color(0xFFECFDF5);
        iconColor = AppColors.success;
        break;
      case 'badge':
        icon = Icons.emoji_events;
        backgroundColor = Color(0xFFFFFBEB);
        iconColor = AppColors.accent;
        break;
      case 'social':
        icon = Icons.people;
        backgroundColor = Color(0xFFF3E8FF);
        iconColor = Color(0xFF9333EA);
        break;
      default:
        icon = Icons.notifications;
        backgroundColor = Color(0xFFEFF6FF);
        iconColor = Color(0xFF004E89);
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: AppColors.border,
          ),
          SizedBox(height: 16),
          Text('Nenhuma notificação', style: AppTextStyles.h3),
          SizedBox(height: 8),
          Text(
            'Você está em dia!',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  List _getFilteredNotifications(provider) {
    final allNotifications = provider.notifications;
    if (_selectedTab == 0) return allNotifications;

    final typeMap = {1: 'offer', 2: 'checkin', 3: 'social', 4: 'system'};
    final filterType = typeMap[_selectedTab];

    return allNotifications.where((n) => n.type == filterType).toList();
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'Há ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Há ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Há ${difference.inDays} dias';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _handleNotificationTap(notification) async {
    final user = context.read<LoginProvider>().currentUser;
    if (user != null) {
      await context.read<NotificationsProvider>().markAsRead(
        notification.id,
        user.id,
      );
    }

    if (notification.data != null) {
      final data = notification.data!;
      if (data.containsKey('placeId')) {
        Navigator.pushNamed(
          context,
          '/place-details',
          arguments: {'placeId': data['placeId']},
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    final user = context.read<LoginProvider>().currentUser;
    if (user != null) {
      await context.read<NotificationsProvider>().markAllAsRead(user.id);
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    final user = context.read<LoginProvider>().currentUser;
    if (user != null) {
      await context.read<NotificationsProvider>().deleteNotification(
        notificationId,
        user.id,
      );
    }
  }
}
