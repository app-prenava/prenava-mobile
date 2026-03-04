import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../community/data/datasources/community_remote_datasource.dart';
import '../../../community/domain/entities/post.dart';

/// Provider that fetches the top 3 most-liked community posts for "Postingan Populer"
final popularPostsProvider = FutureProvider<List<Post>>((ref) async {
  final dio = ref.watch(appDioProvider);
  final datasource = CommunityRemoteDatasource(dio);

  final result = await datasource.getAllPosts(page: 1, limit: 20);
  final posts = result['posts'] as List<dynamic>;

  // Sort by apresiasi (likes) descending and take top 3
  final sorted = posts.cast<Post>().toList()
    ..sort((a, b) => b.apresiasi.compareTo(a.apresiasi));

  return sorted.take(3).toList();
});
