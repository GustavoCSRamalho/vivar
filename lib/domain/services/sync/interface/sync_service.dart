// // domain/services/sync/sync_service.dart

// enum SyncStatus { idle, syncing, synced, error, pending }

// enum SyncOperation { create, update, delete }

// class SyncQueueItem {
//   final String entityType;
//   final String entityId;
//   final SyncOperation operation;
//   final DateTime timestamp;
//   final Map<String, dynamic>? data;

//   SyncQueueItem({
//     required this.entityType,
//     required this.entityId,
//     required this.operation,
//     required this.timestamp,
//     this.data,
//   });
// }

// /// Contrato do serviço de sincronização
// abstract class SyncServiceProtocol {
//   /// Sincroniza uma entidade específica
//   Future<void> syncEntity({
//     required String entityType,
//     required String entityId,
//     required SyncOperation operation,
//     Map<String, dynamic>? data,
//   });

//   /// Sincroniza todos os dados pendentes
//   Future<void> syncPendingData();

//   /// Stream do status de sincronização
//   Stream<SyncStatus> get syncStatusStream;

//   /// Adiciona item na fila de sincronização
//   Future<void> addToSyncQueue({
//     required String entityType,
//     required String entityId,
//     required SyncOperation operation,
//     Map<String, dynamic>? data,
//   });

//   /// Remove item da fila de sincronização
//   Future<void> removeFromSyncQueue(String entityId);

//   /// Busca itens pendentes na fila
//   Future<List<SyncQueueItem>> getPendingItems();

//   /// Verifica se há conexão com internet
//   Future<bool> hasConnection();
// }
