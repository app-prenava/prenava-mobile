import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class CommunityRemoteDatasource {
  final Dio _dio;

  CommunityRemoteDatasource(this._dio);

  Map<String, dynamic>? _lastThreadDetailData;
  int? _lastThreadDetailId;

  Future<List<PostModel>> getAllPosts() async {
    try {
      final response = await _dio.get('/komunitas');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> items = response.data['Komunitas'] ?? [];
        return items
            .map((item) => PostModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil postingan');
    }
  }

  Future<PostModel> getPostById(int id) async {
    try {
      try {
        final response = await _dio.get('/threads/detail/$id');

        if (response.statusCode == 200 && response.data != null) {
          final responseMap = response.data is Map 
              ? Map<String, dynamic>.from(response.data as Map)
              : <String, dynamic>{};
          
          Map<String, dynamic> data;
          if (responseMap.containsKey('data')) {
            data = Map<String, dynamic>.from(responseMap['data'] as Map);
          } else {
            data = responseMap;
          }
          
          _lastThreadDetailData = data;
          _lastThreadDetailId = id;
          
          return PostModel.fromThreadsJson(data);
        }
      } on DioException {
        // Fallback to old endpoint
      }
      
      final response = await _dio.get('/komunitas/$id');

      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic> data;
        
        if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          if (responseMap.containsKey('data')) {
            data = Map<String, dynamic>.from(responseMap['data'] as Map);
          } else if (responseMap.containsKey('post')) {
            data = Map<String, dynamic>.from(responseMap['post'] as Map);
          } else if (responseMap.containsKey('komunitas')) {
            data = Map<String, dynamic>.from(responseMap['komunitas'] as Map);
          } else {
            data = responseMap;
          }
        } else {
          throw Exception('Invalid response format');
        }
        
        return PostModel.fromJson(data);
      }

      throw Exception('Post tidak ditemukan');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil detail post');
    }
  }

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

      final response = await _dio.post('/komunitas/add', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          
          Map<String, dynamic>? postData;
          if (responseMap.containsKey('data')) {
            postData = responseMap['data'] as Map<String, dynamic>?;
          } else if (responseMap.containsKey('komunitas')) {
            postData = responseMap['komunitas'] as Map<String, dynamic>?;
          } else if (responseMap.containsKey('post')) {
            postData = responseMap['post'] as Map<String, dynamic>?;
          } else if (responseMap.containsKey('id') || responseMap.containsKey('post_id')) {
            postData = responseMap;
          }
          
          if (postData != null) {
            return PostModel.fromJson(postData);
          }
        }
        
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
      throw Exception(e.response?.data['message'] ?? 'Gagal membuat postingan');
    }
  }

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

  Future<List<CommentModel>> getComments(int postId) async {
    try {
      List<dynamic> commentsData = [];
      
      if (_lastThreadDetailId == postId && _lastThreadDetailData != null && _lastThreadDetailData!.containsKey('comments')) {
        commentsData = (_lastThreadDetailData!['comments'] as List?) ?? [];
      } else {
        try {
          final response = await _dio.get('/threads/detail/$postId');
          
          if (response.statusCode == 200 && response.data != null) {
            final responseMap = response.data is Map 
                ? Map<String, dynamic>.from(response.data as Map)
                : <String, dynamic>{};
            
            Map<String, dynamic> data;
            if (responseMap.containsKey('data')) {
              data = Map<String, dynamic>.from(responseMap['data'] as Map);
            } else {
              data = responseMap;
            }
            
            _lastThreadDetailData = data;
            _lastThreadDetailId = postId;
            
            commentsData = (data['comments'] as List?) ?? [];
          }
        } on DioException {
          final response = await _dio.get('/komunitas/komen/$postId');
          
          if (response.statusCode == 200 && response.data != null) {
            if (response.data is List) {
              commentsData = response.data as List;
            } else if (response.data is Map) {
              final responseMap = Map<String, dynamic>.from(response.data as Map);
              
              final possibleKeys = ['comments', 'Comments', 'data', 'komentar', 'Komentar'];
              for (final key in possibleKeys) {
                if (responseMap.containsKey(key) && responseMap[key] is List) {
                  commentsData = responseMap[key] as List;
                  break;
                }
              }
            }
          }
        }
      }
      
      final comments = <CommentModel>[];
      for (var i = 0; i < commentsData.length; i++) {
        try {
          final item = Map<String, dynamic>.from(commentsData[i] as Map);
          final comment = CommentModel.fromJson(item);
          comments.add(comment);
        } catch (_) {}
      }
      
      return comments;

    } on DioException {
      return [];
    } catch (_) {
      return [];
    }
  }
  
  void clearCache() {
    _lastThreadDetailData = null;
    _lastThreadDetailId = null;
  }

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

  Future<void> deletePost(int postId) async {
    try {
      await _dio.delete('/komunitas/history/$postId');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus post');
    }
  }

  Future<void> deleteAllPosts() async {
    try {
      await _dio.delete('/komunitas/history/deleteAll');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus semua post');
    }
  }
}
