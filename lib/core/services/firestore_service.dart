// core/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Serviço centralizado para operações no Firestore
/// Usado por DataSources e Repositories
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== GETTERS ====================

  /// Instância do Firestore
  FirebaseFirestore get instance => _firestore;

  /// Timestamp do servidor
  FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  // ==================== COLLECTIONS ====================

  /// Coleção de usuários
  CollectionReference get users => _firestore.collection('users');

  /// Coleção de produtos
  CollectionReference get products => _firestore.collection('products');

  /// Coleção de categorias
  CollectionReference get categories => _firestore.collection('categories');

  /// Coleção de pedidos
  CollectionReference get orders => _firestore.collection('orders');

  /// Coleção de endereços
  CollectionReference get addresses => _firestore.collection('addresses');

  /// Coleção de favoritos
  CollectionReference get favorites => _firestore.collection('favorites');

  /// Coleção de carrinho
  CollectionReference get cart => _firestore.collection('cart');

  /// Coleção de avaliações
  CollectionReference get reviews => _firestore.collection('reviews');

  /// Coleção de notificações
  CollectionReference get notifications =>
      _firestore.collection('notifications');

  // ==================== CRUD GENÉRICO ====================

  /// Cria ou atualiza um documento
  Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    try {
      debugPrint('💾 Salvando documento: $collection/$docId');

      await _firestore
          .collection(collection)
          .doc(docId)
          .set(data, SetOptions(merge: merge));

      debugPrint('✅ Documento salvo com sucesso');
    } catch (e) {
      debugPrint('❌ Erro ao salvar documento: $e');
      rethrow;
    }
  }

  /// Obtém um documento
  Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      debugPrint('📖 Buscando documento: $collection/$docId');

      final doc = await _firestore.collection(collection).doc(docId).get();

      if (!doc.exists) {
        debugPrint('⚠️ Documento não encontrado');
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;

      debugPrint('✅ Documento encontrado');
      return data;
    } catch (e) {
      debugPrint('❌ Erro ao buscar documento: $e');
      rethrow;
    }
  }

  /// Atualiza campos específicos de um documento
  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      debugPrint('✏️ Atualizando documento: $collection/$docId');

      await _firestore.collection(collection).doc(docId).update(data);

      debugPrint('✅ Documento atualizado');
    } catch (e) {
      debugPrint('❌ Erro ao atualizar documento: $e');
      rethrow;
    }
  }

  /// Deleta um documento
  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      debugPrint('🗑️ Deletando documento: $collection/$docId');

      await _firestore.collection(collection).doc(docId).delete();

      debugPrint('✅ Documento deletado');
    } catch (e) {
      debugPrint('❌ Erro ao deletar documento: $e');
      rethrow;
    }
  }

  /// Adiciona um novo documento (com ID automático)
  Future<String> addDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      debugPrint('➕ Adicionando documento em: $collection');

      final doc = await _firestore.collection(collection).add(data);

      debugPrint('✅ Documento adicionado: ${doc.id}');
      return doc.id;
    } catch (e) {
      debugPrint('❌ Erro ao adicionar documento: $e');
      rethrow;
    }
  }

  // ==================== QUERIES ====================

  /// Busca documentos com filtros
  Future<List<Map<String, dynamic>>> queryDocuments({
    required String collection,
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      debugPrint('🔍 Buscando documentos em: $collection');

      Query query = _firestore.collection(collection);

      // Aplica filtros
      if (filters != null) {
        for (final filter in filters) {
          query = query.where(
            filter.field,
            isEqualTo: filter.isEqualTo,
            isNotEqualTo: filter.isNotEqualTo,
            isLessThan: filter.isLessThan,
            isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
            isGreaterThan: filter.isGreaterThan,
            isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
            arrayContains: filter.arrayContains,
            arrayContainsAny: filter.arrayContainsAny,
            whereIn: filter.whereIn,
            whereNotIn: filter.whereNotIn,
            isNull: filter.isNull,
          );
        }
      }

      // Ordena
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      // Limita
      if (limit != null) {
        query = query.limit(limit);
      }

      // Executa query
      final snapshot = await query.get();

      final documents = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      debugPrint('✅ ${documents.length} documentos encontrados');
      return documents;
    } catch (e) {
      debugPrint('❌ Erro ao buscar documentos: $e');
      rethrow;
    }
  }

  /// Busca documentos onde um campo contém um valor (em array)
  Future<List<Map<String, dynamic>>> queryArrayContains({
    required String collection,
    required String field,
    required dynamic value,
    int? limit,
  }) async {
    try {
      debugPrint('🔍 Buscando documentos com array: $collection/$field');

      Query query = _firestore
          .collection(collection)
          .where(field, arrayContains: value);

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();

      final documents = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      debugPrint('✅ ${documents.length} documentos encontrados');
      return documents;
    } catch (e) {
      debugPrint('❌ Erro ao buscar documentos: $e');
      rethrow;
    }
  }

  // ==================== STREAMS ====================

  /// Stream de um documento
  Stream<Map<String, dynamic>?> documentStream({
    required String collection,
    required String docId,
  }) {
    return _firestore.collection(collection).doc(docId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return null;
      final data = snapshot.data() as Map<String, dynamic>;
      data['id'] = snapshot.id;
      return data;
    });
  }

  /// Stream de uma coleção
  Stream<List<Map<String, dynamic>>> collectionStream({
    required String collection,
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = _firestore.collection(collection);

    // Aplica filtros
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(
          filter.field,
          isEqualTo: filter.isEqualTo,
          isNotEqualTo: filter.isNotEqualTo,
          isLessThan: filter.isLessThan,
          isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
          isGreaterThan: filter.isGreaterThan,
          isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
          arrayContains: filter.arrayContains,
          arrayContainsAny: filter.arrayContainsAny,
          whereIn: filter.whereIn,
          whereNotIn: filter.whereNotIn,
          isNull: filter.isNull,
        );
      }
    }

    // Ordena
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    // Limita
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // ==================== BATCH OPERATIONS ====================

  /// Executa operações em lote
  Future<void> runBatch(Function(WriteBatch batch) operations) async {
    try {
      debugPrint('📦 Executando batch...');

      final batch = _firestore.batch();
      operations(batch);
      await batch.commit();

      debugPrint('✅ Batch executado com sucesso');
    } catch (e) {
      debugPrint('❌ Erro ao executar batch: $e');
      rethrow;
    }
  }

  /// Executa múltiplas operações em batch
  Future<void> batchWrite(List<BatchOperation> operations) async {
    try {
      debugPrint('📦 Executando ${operations.length} operações em batch...');

      final batch = _firestore.batch();

      for (final operation in operations) {
        final ref = _firestore
            .collection(operation.collection)
            .doc(operation.docId);

        switch (operation.type) {
          case BatchOperationType.set:
            batch.set(ref, operation.data!, SetOptions(merge: operation.merge));
            break;
          case BatchOperationType.update:
            batch.update(ref, operation.data!);
            break;
          case BatchOperationType.delete:
            batch.delete(ref);
            break;
        }
      }

      await batch.commit();

      debugPrint('✅ Batch executado com sucesso');
    } catch (e) {
      debugPrint('❌ Erro ao executar batch: $e');
      rethrow;
    }
  }

  // ==================== TRANSACTIONS ====================

  /// Executa uma transação
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction,
  ) async {
    try {
      debugPrint('🔄 Executando transação...');

      final result = await _firestore.runTransaction(updateFunction);

      debugPrint('✅ Transação executada com sucesso');
      return result;
    } catch (e) {
      debugPrint('❌ Erro ao executar transação: $e');
      rethrow;
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Obtém referência de documento
  DocumentReference getDocRef(String collection, String docId) {
    return _firestore.collection(collection).doc(docId);
  }

  /// Obtém referência de coleção
  CollectionReference getCollectionRef(String collection) {
    return _firestore.collection(collection);
  }

  /// Verifica se documento existe
  Future<bool> documentExists({
    required String collection,
    required String docId,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      return doc.exists;
    } catch (e) {
      debugPrint('❌ Erro ao verificar existência: $e');
      return false;
    }
  }

  /// Conta documentos em uma coleção
  Future<int> countDocuments({
    required String collection,
    List<QueryFilter>? filters,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      if (filters != null) {
        for (final filter in filters) {
          query = query.where(filter.field, isEqualTo: filter.isEqualTo);
        }
      }

      final snapshot = await query.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('❌ Erro ao contar documentos: $e');
      return 0;
    }
  }
}

// ==================== HELPER CLASSES ====================

/// Filtro para queries
class QueryFilter {
  final String field;
  final dynamic isEqualTo;
  final dynamic isNotEqualTo;
  final dynamic isLessThan;
  final dynamic isLessThanOrEqualTo;
  final dynamic isGreaterThan;
  final dynamic isGreaterThanOrEqualTo;
  final dynamic arrayContains;
  final List<dynamic>? arrayContainsAny;
  final List<dynamic>? whereIn;
  final List<dynamic>? whereNotIn;
  final bool? isNull;

  QueryFilter({
    required this.field,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}

/// Tipo de operação em batch
enum BatchOperationType { set, update, delete }

/// Operação para batch
class BatchOperation {
  final String collection;
  final String docId;
  final BatchOperationType type;
  final Map<String, dynamic>? data;
  final bool merge;

  BatchOperation({
    required this.collection,
    required this.docId,
    required this.type,
    this.data,
    this.merge = true,
  });

  /// Cria operação de set
  factory BatchOperation.set({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) {
    return BatchOperation(
      collection: collection,
      docId: docId,
      type: BatchOperationType.set,
      data: data,
      merge: merge,
    );
  }

  /// Cria operação de update
  factory BatchOperation.update({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) {
    return BatchOperation(
      collection: collection,
      docId: docId,
      type: BatchOperationType.update,
      data: data,
    );
  }

  /// Cria operação de delete
  factory BatchOperation.delete({
    required String collection,
    required String docId,
  }) {
    return BatchOperation(
      collection: collection,
      docId: docId,
      type: BatchOperationType.delete,
    );
  }
}
