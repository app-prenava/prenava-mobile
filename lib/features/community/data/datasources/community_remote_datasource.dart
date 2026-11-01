import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class CommunityRemoteDatasource {
  final Dio _dio;

  CommunityRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> getAllPosts({
    int page = 1,
    int limit = 10,
    String? kategori,
    String? filter,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (kategori != null && kategori.isNotEmpty && kategori != 'semua' && kategori != 'all') {
        queryParams['kategori'] = kategori;
      }
      if (filter != null && filter.isNotEmpty && filter != 'all') {
        queryParams['filter'] = filter;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _dio.get(
        '/komunitas',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> items = response.data['Komunitas'] ?? [];
        final pagination = response.data['pagination'] as Map<String, dynamic>? ?? {};
        final posts = items
            .map((item) => PostModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();

        return {
          'posts': posts,
          'current_page': pagination['current_page'] ?? page,
          'last_page': pagination['last_page'] ?? 1,
          'total': pagination['total'] ?? posts.length,
        };
      }

      return {
        'posts': <PostModel>[],
        'current_page': 1,
        'last_page': 1,
        'total': 0,
      };
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil postingan');
    }
  }

  Future<PostModel> getPostById(int id) async {
    try {
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
    String? kategori,
    bool isAnonymous = false,
    String? gambar,
  }) async {
    try {
      final data = <String, dynamic>{
        'judul': judul,
        'deskripsi': deskripsi,
        'kategori': kategori ?? 'umum',
        'is_anonymous': isAnonymous,
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
          kategori: kategori ?? 'umum',
          isAnonymous: isAnonymous,
          apresiasi: 0,
          komentar: 0,
          user: const PostUserModel(id: 0, name: 'User'),
        );
      }

      throw Exception('Gagal membuat post');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal membuat post');
    }
  }

  Future<Map<String, dynamic>> toggleLike(int postId) async {
    try {
      final response = await _dio.post('/komunitas/like/add/$postId');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return {
          'is_liked': data['is_liked'] ?? false,
          'apresiasi': data['apresiasi'] ?? 0,
        };
      }

      throw Exception('Gagal toggle like');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal toggle like');
    }
  }

  Future<List<CommentModel>> getComments(int postId) async {
    try {
      final response = await _dio.get('/komunitas/komen/$postId');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> items = response.data['data'] ?? [];
        return items
            .map((item) => CommentModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil komentar');
    }
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
        final data = response.data['data'] as Map<String, dynamic>;
        return CommentModel.fromJson(data);
      }

      throw Exception('Gagal menambahkan komentar');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menambahkan komentar');
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      final response = await _dio.delete('/komunitas/komen/delete/$commentId');

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Gagal menghapus komentar');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus komentar');
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      final response = await _dio.delete('/komunitas/history/$postId');

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Gagal menghapus post');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus post');
    }
  }

  Future<void> deleteAllPosts() async {
    try {
      final response = await _dio.delete('/komunitas/history/deleteAll');

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Gagal menghapus semua post');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal menghapus semua post');
    }
  }
}
