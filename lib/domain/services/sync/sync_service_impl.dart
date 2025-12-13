// // data/services/sync/sync_service_impl.dart

// import 'dart:async';
// import 'package:sqflite/sqflite.dart';
// import '../../../../packages/database_module/lib/src/database_helper.dart';
// import 'package:vivar/domain/services/sync/interface/sync_service.dart';

// class SyncServiceImpl implements SyncServiceProtocol {
//   final DatabaseHelper _dbHelper;
//   final dynamic _connectivity; // ConnectivityService
//   final Map<String, dynamic> _remoteDatasources; // Map de datasources remotos

//   final _syncStatusController = StreamController<SyncStatus>.broadcast();

//   static const String _syncQueueTable = 'sync_queue';

//   SyncServiceImpl({
//     DatabaseHelper? dbHelper,
//     required dynamic connectivity,
//     required Map<String, dynamic> remoteDatasources,
//   }) : _dbHelper = dbHelper ?? DatabaseHelper(),
//        _connectivity = connectivity,
//        _remoteDatasources = remoteDatasources;

//   Future<Database> get _database async => await _dbHelper.database;

//   @override
//   Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

//   @override
//   Future<bool> hasConnection() async {
//     try {
//       return await _connectivity.hasConnection();
//     } catch (e) {
//       return false;
//     }
//   }

//   @override
//   Future<void> syncEntity({
//     required String entityType,
//     required String entityId,
//     required SyncOperation operation,
//     Map<String, dynamic>? data,
//   }) async {
//     if (!await hasConnection()) {
//       await addToSyncQueue(
//         entityType: entityType,
//         entityId: entityId,
//         operation: operation,
//         data: data,
//       );
//       _syncStatusController.add(SyncStatus.pending);
//       return;
//     }

//     try {
//       _syncStatusController.add(SyncStatus.syncing);

//       final remoteDatasource = _remoteDatasources[entityType];
//       if (remoteDatasource == null) {
//         throw Exception('Remote datasource não encontrado para $entityType');
//       }

//       switch (operation) {
//         case SyncOperation.create:
//         case SyncOperation.update:
//           if (data == null) {
//             throw Exception('Data é obrigatório para operações create/update');
//           }
//           await remoteDatasource.saveMerchant(_mapToEntity(data));
//           break;
//         case SyncOperation.delete:
//           await remoteDatasource.deleteMerchant(entityId);
//           break;
//       }

//       await removeFromSyncQueue(entityId);
//       _syncStatusController.add(SyncStatus.synced);
//     } catch (e) {
//       print('❌ Erro ao sincronizar entidade: $e');
//       await addToSyncQueue(
//         entityType: entityType,
//         entityId: entityId,
//         operation: operation,
//         data: data,
//       );
//       _syncStatusController.add(SyncStatus.error);
//       rethrow;
//     }
//   }

//   @override
//   Future<void> syncPendingData() async {
//     if (!await hasConnection()) {
//       print('⚠️ Sem conexão. Sincronização adiada.');
//       return;
//     }

//     try {
//       _syncStatusController.add(SyncStatus.syncing);

//       final pendingItems = await getPendingItems();

//       for (final item in pendingItems) {
//         try {
//           await syncEntity(
//             entityType: item.entityType,
//             entityId: item.entityId,
//             operation: item.operation,
//             data: item.data,
//           );
//         } catch (e) {
//           print('❌ Erro ao sincronizar item ${item.entityId}: $e');
//           // Continua para o próximo item
//         }
//       }

//       _syncStatusController.add(SyncStatus.synced);
//     } catch (e) {
//       print('❌ Erro ao sincronizar dados pendentes: $e');
//       _syncStatusController.add(SyncStatus.error);
//     }
//   }

//   @override
//   Future<void> addToSyncQueue({
//     required String entityType,
//     required String entityId,
//     required SyncOperation operation,
//     Map<String, dynamic>? data,
//   }) async {
//     try {
//       final db = await _database;

//       await db.insert(_syncQueueTable, {
//         'entity_type': entityType,
//         'entity_id': entityId,
//         'operation': operation.name,
//         'data': data != null ? data.toString() : null,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//       }, conflictAlgorithm: ConflictAlgorithm.replace);
//     } catch (e) {
//       print('❌ Erro ao adicionar na fila de sync: $e');
//       rethrow;
//     }
//   }

//   @override
//   Future<void> removeFromSyncQueue(String entityId) async {
//     try {
//       final db = await _database;

//       await db.delete(
//         _syncQueueTable,
//         where: 'entity_id = ?',
//         whereArgs: [entityId],
//       );
//     } catch (e) {
//       print('❌ Erro ao remover da fila de sync: $e');
//     }
//   }

//   @override
//   Future<List<SyncQueueItem>> getPendingItems() async {
//     try {
//       final db = await _database;

//       final List<Map<String, dynamic>> maps = await db.query(
//         _syncQueueTable,
//         orderBy: 'timestamp ASC',
//       );

//       return maps
//           .map(
//             (map) => SyncQueueItem(
//               entityType: map['entity_type'] as String,
//               entityId: map['entity_id'] as String,
//               operation: SyncOperation.values.firstWhere(
//                 (e) => e.name == map['operation'],
//               ),
//               timestamp: DateTime.fromMillisecondsSinceEpoch(
//                 map['timestamp'] as int,
//               ),
//               data: map['data'] != null
//                   ? _parseData(map['data'] as String)
//                   : null,
//             ),
//           )
//           .toList();
//     } catch (e) {
//       print('❌ Erro ao buscar itens pendentes: $e');
//       return [];
//     }
//   }

//   // Método auxiliar para converter Map para Entity (temporário)
//   dynamic _mapToEntity(Map<String, dynamic> data) {
//     // Este método será substituído pela lógica específica de cada entity
//     return data;
//   }

//   // Método auxiliar para parsear data string
//   Map<String, dynamic>? _parseData(String dataString) {
//     // Implementar parsing conforme necessário
//     return null;
//   }

//   void dispose() {
//     _syncStatusController.close();
//   }
// }
