import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class CommunityRemoteDatasource {
  final Dio _dio;

  CommunityRemoteDatasource(this._dio);

  /// GET /api/komunitas - Get all posts
  Future<List<PostModel>> getAllPosts() async {
    try {
      developer.log('Fetching all posts...', name: 'Community');
      final response = await _dio.get('/komunitas');

      if (response.statusCode == 200 && response.data != null) {
        // Backend returns { Komunitas: [...] }
        final List<dynamic> items = response.data['Komunitas'] ?? [];
        developer.log('Found ${items.length} posts in Komunitas key', name: 'Community');
        
        return items
            .map((item) => PostModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      developer.log('Get posts error: ${e.response?.data}', name: 'Community');
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil postingan');
    }
  }

  /// GET /api/komunitas/{id} - Get post by id
  Future<PostModel> getPostById(int id) async {
    try {
      final response = await _dio.get('/komunitas/$id');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map<String, dynamic> 
            ? response.data 
            : response.data['data'];
        return PostModel.fromJson(data as Map<String, dynamic>);
      }

      throw Exception('Post tidak ditemukan');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil detail post');
    }
  }

  /// POST /api/komunitas/add - Create new post
  Future<PostModel> createPost({
    required String judul,
    required String deskripsi,
    String? gambar,
  }) async {
    try {
      final data = {
        'judul': judul,
        'deskripsi': deskripsi,
      };
      
      if (gambar != null && gambar.isNotEmpty) {
        data['gambar'] = gambar;
      }

      print('Creating post with data: $data');
      final response = await _dio.post('/komunitas/add', data: data);
      print('Create post response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle different response structures
        if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          
          // Try to find the post data in different keys
          Map<String, dynamic>? postData;
          if (responseMap.containsKey('data')) {
            postData = responseMap['data'] as Map<String, dynamic>?;
          } else if (responseMap.containsKey('komunitas')) {
            postData = responseMap['komunitas'] as Map<String, dynamic>?;
          } else if (responseMap.containsKey('post')) {
            postData = responseMap['post'] as Map<String, dynamic>?;
          } else if (responseMap.containsKey('id') || responseMap.containsKey('post_id')) {
            // The response is the post data itself
            postData = responseMap;
          }
          
          if (postData != null) {
            return PostModel.fromJson(postData);
          }
        }
        
        // If we can't parse the response but status is success, return a dummy model
        // The list will be refreshed anyway
        return PostModel(
          id: 0,
          judul: judul,
          deskripsi: deskripsi,
          apresiasi: 0,
          komentar: 0,
          user: const PostUserModel(id: 0, name: 'User'),
        );
      }

      throw Exception('Gagal membuat postingan');
    } on DioException catch (e) {
      print('Create post error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Gagal membuat postingan');
    }
  }

  /// POST /api/komunitas/like/add/{id} - Toggle like
  Future<Map<String, dynamic>> toggleLike(int postId) async {
    try {
      final response = await _dio.post('/komunitas/like/add/$postId');

      if (response.statusCode == 200 && response.data != null) {
        return {
          'is_liked': response.data['is_liked'] as bool? ?? false,
          'apresiasi': response.data['apresiasi'] as int? ?? 0,
        };
      }

      throw Exception('Gagal toggle like');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal toggle like');
    }
  }

  /// GET /api/komunitas/komen/{id} - Get comments for a post
  Future<List<CommentModel>> getComments(int postId) async {
    try {
      final response = await _dio.get('/komunitas/komen/$postId');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data is List 
            ? response.data 
            : (response.data['data'] as List? ?? []);
        
        return data
            .map((item) => CommentModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil komentar');
    }
  }

  /// POST /api/komunitas/komen/add/{id} - Add comment
  Future<CommentModel> addComment({
    required int postId,
    required String komentar,
  }) async {
    try {
      final response = await _dio.post(
        '/komunitas/komen/add/$postId',
        data: {'komentar': komentar},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data is Map<String, dynamic> 
            ? response.data 
            : response.data['data'];
        
        if (responseData != null) {
          return CommentModel.fromJson(responseData as Map<String, dynamic>);
        }
      }

      throw Exception('Gagal menambah komentar');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menambah komentar');
    }
  }

  /// DELETE /api/komunitas/history/{id} - Delete post
  Future<void> deletePost(int postId) async {
    try {
      await _dio.delete('/komunitas/history/$postId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus post');
    }
  }

  /// DELETE /api/komunitas/history/deleteAll - Delete all posts
  Future<void> deleteAllPosts() async {
    try {
      await _dio.delete('/komunitas/history/deleteAll');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus semua post');
    }
  }
}

