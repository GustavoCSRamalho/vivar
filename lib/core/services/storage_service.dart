// // core/services/storage_service.dart

// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart' as path;

// /// Serviço centralizado para operações no Firebase Storage
// /// Usado para upload/download de arquivos e imagens
// class StorageService {
//   static final StorageService _instance = StorageService._internal();
//   factory StorageService() => _instance;
//   StorageService._internal();

//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   // ==================== GETTERS ====================

//   /// Instância do Storage
//   FirebaseStorage get instance => _storage;

//   // ==================== FOLDER PATHS ====================

//   /// Pasta raiz de usuários
//   static const String _usersPath = 'users';

//   /// Pasta de avatares
//   static const String _avatarsPath = '$_usersPath/avatars';

//   /// Pasta de produtos
//   static const String _productsPath = 'products';

//   /// Pasta de imagens de produtos
//   static const String _productImagesPath = '$_productsPath/images';

//   /// Pasta de categorias
//   static const String _categoriesPath = 'categories';

//   /// Pasta de imagens de categorias
//   static const String _categoryImagesPath = '$_categoriesPath/images';

//   /// Pasta de documentos
//   static const String _documentsPath = 'documents';

//   /// Pasta temporária
//   static const String _tempPath = 'temp';

//   // ==================== UPLOAD METHODS ====================

//   /// Upload genérico de arquivo
//   Future<String> uploadFile({
//     required File file,
//     required String path,
//     Map<String, String>? metadata,
//     Function(double)? onProgress,
//   }) async {
//     try {
//       debugPrint('📤 Upload iniciado: $path');

//       final ref = _storage.ref().child(path);

//       // Prepara metadata
//       final fileMetadata = SettableMetadata(
//         contentType: _getContentType(path),
//         customMetadata: {
//           'uploadedAt': DateTime.now().toIso8601String(),
//           ...?metadata,
//         },
//       );

//       // Inicia upload
//       final uploadTask = ref.putFile(file, fileMetadata);

//       // Monitora progresso
//       if (onProgress != null) {
//         uploadTask.snapshotEvents.listen((event) {
//           final progress = event.bytesTransferred / event.totalBytes;
//           onProgress(progress);
//           debugPrint('📊 Progresso: ${(progress * 100).toStringAsFixed(1)}%');
//         });
//       }

//       // Aguarda conclusão
//       await uploadTask;

//       // Obtém URL
//       final downloadUrl = await ref.getDownloadURL();

//       debugPrint('✅ Upload concluído: $downloadUrl');
//       return downloadUrl;
//     } catch (e) {
//       debugPrint('❌ Erro no upload: $e');
//       rethrow;
//     }
//   }

//   /// Upload de bytes
//   Future<String> uploadBytes({
//     required Uint8List bytes,
//     required String path,
//     Map<String, String>? metadata,
//     Function(double)? onProgress,
//   }) async {
//     try {
//       debugPrint('📤 Upload de bytes iniciado: $path');

//       final ref = _storage.ref().child(path);

//       final fileMetadata = SettableMetadata(
//         contentType: _getContentType(path),
//         customMetadata: {
//           'uploadedAt': DateTime.now().toIso8601String(),
//           ...?metadata,
//         },
//       );

//       final uploadTask = ref.putData(bytes, fileMetadata);

//       if (onProgress != null) {
//         uploadTask.snapshotEvents.listen((event) {
//           final progress = event.bytesTransferred / event.totalBytes;
//           onProgress(progress);
//         });
//       }

//       await uploadTask;
//       final downloadUrl = await ref.getDownloadURL();

//       debugPrint('✅ Upload concluído: $downloadUrl');
//       return downloadUrl;
//     } catch (e) {
//       debugPrint('❌ Erro no upload: $e');
//       rethrow;
//     }
//   }

//   // ==================== USER AVATAR ====================

//   /// Upload de avatar do usuário
//   Future<String> uploadUserAvatar({
//     required String userId,
//     required File imageFile,
//     Function(double)? onProgress,
//   }) async {
//     final extension = path.extension(imageFile.path);
//     final filePath = '$_avatarsPath/$userId$extension';

//     return uploadFile(
//       file: imageFile,
//       path: filePath,
//       metadata: {'userId': userId, 'type': 'avatar'},
//       onProgress: onProgress,
//     );
//   }

//   /// Deleta avatar do usuário
//   Future<void> deleteUserAvatar(String userId) async {
//     await _deleteFileByPrefix('$_avatarsPath/$userId');
//   }

//   // ==================== PRODUCT IMAGES ====================

//   /// Upload de imagem de produto
//   Future<String> uploadProductImage({
//     required String productId,
//     required File imageFile,
//     int? index,
//     Function(double)? onProgress,
//   }) async {
//     final extension = path.extension(imageFile.path);
//     final suffix = index != null ? '_$index' : '';
//     final filePath = '$_productImagesPath/$productId$suffix$extension';

//     return uploadFile(
//       file: imageFile,
//       path: filePath,
//       metadata: {
//         'productId': productId,
//         'type': 'product_image',
//         if (index != null) 'index': index.toString(),
//       },
//       onProgress: onProgress,
//     );
//   }

//   /// Upload de múltiplas imagens de produto
//   Future<List<String>> uploadProductImages({
//     required String productId,
//     required List<File> imageFiles,
//     Function(int current, int total)? onProgress,
//   }) async {
//     final urls = <String>[];

//     for (int i = 0; i < imageFiles.length; i++) {
//       onProgress?.call(i + 1, imageFiles.length);

//       final url = await uploadProductImage(
//         productId: productId,
//         imageFile: imageFiles[i],
//         index: i,
//       );

//       urls.add(url);
//     }

//     return urls;
//   }

//   /// Deleta imagem de produto
//   Future<void> deleteProductImage(String productId, {int? index}) async {
//     final suffix = index != null ? '_$index' : '';
//     await _deleteFileByPrefix('$_productImagesPath/$productId$suffix');
//   }

//   /// Deleta todas as imagens de um produto
//   Future<void> deleteAllProductImages(String productId) async {
//     try {
//       debugPrint('🗑️ Deletando imagens do produto: $productId');

//       final ref = _storage.ref().child(_productImagesPath);
//       final result = await ref.listAll();

//       int deleted = 0;
//       for (final item in result.items) {
//         if (item.name.startsWith(productId)) {
//           await item.delete();
//           deleted++;
//         }
//       }

//       debugPrint('✅ $deleted imagens deletadas');
//     } catch (e) {
//       debugPrint('❌ Erro ao deletar imagens: $e');
//       rethrow;
//     }
//   }

//   // ==================== CATEGORY IMAGES ====================

//   /// Upload de imagem de categoria
//   Future<String> uploadCategoryImage({
//     required String categoryId,
//     required File imageFile,
//     Function(double)? onProgress,
//   }) async {
//     final extension = path.extension(imageFile.path);
//     final filePath = '$_categoryImagesPath/$categoryId$extension';

//     return uploadFile(
//       file: imageFile,
//       path: filePath,
//       metadata: {'categoryId': categoryId, 'type': 'category_image'},
//       onProgress: onProgress,
//     );
//   }

//   /// Deleta imagem de categoria
//   Future<void> deleteCategoryImage(String categoryId) async {
//     await _deleteFileByPrefix('$_categoryImagesPath/$categoryId');
//   }

//   // ==================== DOCUMENTS ====================

//   /// Upload de documento
//   Future<String> uploadDocument({
//     required String userId,
//     required File documentFile,
//     required String documentName,
//     Function(double)? onProgress,
//   }) async {
//     final extension = path.extension(documentFile.path);
//     final timestamp = DateTime.now().millisecondsSinceEpoch;
//     final fileName = '${userId}_${timestamp}_$documentName$extension';
//     final filePath = '$_documentsPath/$fileName';

//     return uploadFile(
//       file: documentFile,
//       path: filePath,
//       metadata: {
//         'userId': userId,
//         'documentName': documentName,
//         'type': 'document',
//       },
//       onProgress: onProgress,
//     );
//   }

//   /// Deleta documento
//   Future<void> deleteDocument(String filePath) async {
//     await deleteFile(filePath);
//   }

//   // ==================== DOWNLOAD METHODS ====================

//   /// Obtém URL de download
//   Future<String> getDownloadUrl(String path) async {
//     try {
//       debugPrint('🔗 Obtendo URL: $path');

//       final ref = _storage.ref().child(path);
//       final url = await ref.getDownloadURL();

//       debugPrint('✅ URL obtida');
//       return url;
//     } catch (e) {
//       debugPrint('❌ Erro ao obter URL: $e');
//       rethrow;
//     }
//   }

//   /// Download de arquivo
//   Future<Uint8List?> downloadFile(String path) async {
//     try {
//       debugPrint('⬇️ Baixando arquivo: $path');

//       final ref = _storage.ref().child(path);
//       final bytes = await ref.getData();

//       debugPrint('✅ Arquivo baixado: ${bytes?.length} bytes');
//       return bytes;
//     } catch (e) {
//       debugPrint('❌ Erro ao baixar arquivo: $e');
//       rethrow;
//     }
//   }

//   // ==================== DELETE METHODS ====================

//   /// Deleta arquivo
//   Future<void> deleteFile(String path) async {
//     try {
//       debugPrint('🗑️ Deletando arquivo: $path');

//       final ref = _storage.ref().child(path);
//       await ref.delete();

//       debugPrint('✅ Arquivo deletado');
//     } catch (e) {
//       debugPrint('❌ Erro ao deletar arquivo: $e');
//       rethrow;
//     }
//   }

//   /// Deleta pasta inteira
//   Future<void> deleteFolder(String folderPath) async {
//     try {
//       debugPrint('🗑️ Deletando pasta: $folderPath');

//       final ref = _storage.ref().child(folderPath);
//       final result = await ref.listAll();

//       int deleted = 0;

//       // Deleta todos os arquivos
//       for (final item in result.items) {
//         await item.delete();
//         deleted++;
//       }

//       // Deleta subpastas recursivamente
//       for (final prefix in result.prefixes) {
//         await deleteFolder(prefix.fullPath);
//       }

//       debugPrint('✅ Pasta deletada: $deleted arquivos');
//     } catch (e) {
//       debugPrint('❌ Erro ao deletar pasta: $e');
//       rethrow;
//     }
//   }

//   // ==================== LIST METHODS ====================

//   /// Lista arquivos em uma pasta
//   Future<List<String>> listFiles(String folderPath) async {
//     try {
//       debugPrint('📋 Listando arquivos em: $folderPath');

//       final ref = _storage.ref().child(folderPath);
//       final result = await ref.listAll();

//       final urls = <String>[];

//       for (final item in result.items) {
//         final url = await item.getDownloadURL();
//         urls.add(url);
//       }

//       debugPrint('✅ ${urls.length} arquivos encontrados');
//       return urls;
//     } catch (e) {
//       debugPrint('❌ Erro ao listar arquivos: $e');
//       rethrow;
//     }
//   }

//   /// Lista todos os arquivos com metadata
//   Future<List<FileMetadata>> listFilesWithMetadata(String folderPath) async {
//     try {
//       debugPrint('📋 Listando arquivos com metadata: $folderPath');

//       final ref = _storage.ref().child(folderPath);
//       final result = await ref.listAll();

//       final files = <FileMetadata>[];

//       for (final item in result.items) {
//         final metadata = await item.getMetadata();
//         final url = await item.getDownloadURL();

//         files.add(
//           FileMetadata(
//             name: item.name,
//             fullPath: item.fullPath,
//             url: url,
//             size: metadata.size ?? 0,
//             contentType: metadata.contentType,
//             createdAt: metadata.timeCreated,
//             updatedAt: metadata.updated,
//             customMetadata: metadata.customMetadata,
//           ),
//         );
//       }

//       debugPrint('✅ ${files.length} arquivos encontrados');
//       return files;
//     } catch (e) {
//       debugPrint('❌ Erro ao listar arquivos: $e');
//       rethrow;
//     }
//   }

//   // ==================== UTILITY METHODS ====================

//   /// Obtém metadata de um arquivo
//   Future<FullMetadata?> getFileMetadata(String path) async {
//     try {
//       final ref = _storage.ref().child(path);
//       return await ref.getMetadata();
//     } catch (e) {
//       debugPrint('❌ Erro ao obter metadata: $e');
//       return null;
//     }
//   }

//   /// Verifica se arquivo existe
//   Future<bool> fileExists(String path) async {
//     try {
//       final ref = _storage.ref().child(path);
//       await ref.getDownloadURL();
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   /// Obtém tamanho do arquivo
//   Future<int?> getFileSize(String path) async {
//     try {
//       final metadata = await getFileMetadata(path);
//       return metadata?.size;
//     } catch (e) {
//       return null;
//     }
//   }

//   // ==================== PRIVATE HELPERS ====================

//   /// Deleta arquivo por prefixo (usado quando não sabemos a extensão)
//   Future<void> _deleteFileByPrefix(String prefix) async {
//     try {
//       debugPrint('🗑️ Deletando arquivo com prefixo: $prefix');

//       final extensions = [
//         'png',
//         'jpg',
//         'jpeg',
//         'webp',
//         'gif',
//         'pdf',
//         'doc',
//         'docx',
//       ];

//       for (final ext in extensions) {
//         try {
//           await deleteFile('$prefix.$ext');
//           debugPrint('✅ Arquivo deletado: $prefix.$ext');
//           return;
//         } catch (e) {
//           continue;
//         }
//       }

//       debugPrint('⚠️ Nenhum arquivo encontrado com o prefixo');
//     } catch (e) {
//       debugPrint('❌ Erro ao deletar arquivo: $e');
//       rethrow;
//     }
//   }

//   /// Determina o content type baseado na extensão
//   String _getContentType(String filePath) {
//     final extension = path.extension(filePath).toLowerCase();

//     switch (extension) {
//       // Imagens
//       case '.jpg':
//       case '.jpeg':
//         return 'image/jpeg';
//       case '.png':
//         return 'image/png';
//       case '.gif':
//         return 'image/gif';
//       case '.webp':
//         return 'image/webp';
//       case '.svg':
//         return 'image/svg+xml';

//       // Documentos
//       case '.pdf':
//         return 'application/pdf';
//       case '.doc':
//         return 'application/msword';
//       case '.docx':
//         return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
//       case '.xls':
//         return 'application/vnd.ms-excel';
//       case '.xlsx':
//         return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
//       case '.txt':
//         return 'text/plain';

//       // Vídeos
//       case '.mp4':
//         return 'video/mp4';
//       case '.mov':
//         return 'video/quicktime';
//       case '.avi':
//         return 'video/x-msvideo';

//       // Áudio
//       case '.mp3':
//         return 'audio/mpeg';
//       case '.wav':
//         return 'audio/wav';

//       default:
//         return 'application/octet-stream';
//     }
//   }
// }

// // ==================== HELPER CLASSES ====================

// /// Metadata de arquivo
// class FileMetadata {
//   final String name;
//   final String fullPath;
//   final String url;
//   final int size;
//   final String? contentType;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final Map<String, String>? customMetadata;

//   FileMetadata({
//     required this.name,
//     required this.fullPath,
//     required this.url,
//     required this.size,
//     this.contentType,
//     this.createdAt,
//     this.updatedAt,
//     this.customMetadata,
//   });

//   /// Tamanho formatado
//   String get formattedSize {
//     if (size < 1024) return '$size B';
//     if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
//     if (size < 1024 * 1024 * 1024) {
//       return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
//     }
//     return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
//   }
// }
