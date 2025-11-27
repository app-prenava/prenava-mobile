import 'dart:developer' as developer;
import '../config/env.dart';

/// Helper class to normalize image URLs from the backend
class ImageUrlHelper {
  /// Get the base URL for images (API base without /api)
  static String get _baseUrl {
    final apiBase = Env.apiBase;
    // Remove /api from the end if present
    String base = apiBase;
    if (base.endsWith('/api')) {
      base = base.substring(0, base.length - 4);
    }
    // Remove trailing slash if present
    if (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    return base;
  }

  /// Normalize image URL from backend response
  /// Handles:
  /// - Relative URLs (e.g., /storage/file.jpg or storage/file.jpg)
  /// - localhost URLs (replaces with correct base URL)
  /// - Already full URLs (always replaces domain with our base URL to ensure consistency)
  static String? normalizeImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      developer.log('ImageUrlHelper: URL is null or empty', name: 'ImageUrlHelper');
      return null;
    }

    developer.log('ImageUrlHelper: Original URL: $url', name: 'ImageUrlHelper');
    final baseUrl = _baseUrl;
    developer.log('ImageUrlHelper: Base URL: $baseUrl', name: 'ImageUrlHelper');

    // Parse the URL to extract the path
    String path;
    String? query;
    
    if (url.startsWith('http://') || url.startsWith('https://')) {
      // Full URL - extract path and query
      final uri = Uri.tryParse(url);
      if (uri != null) {
        path = uri.path;
        query = uri.query.isNotEmpty ? uri.query : null;
        developer.log('ImageUrlHelper: Extracted path from full URL: $path', name: 'ImageUrlHelper');
      } else {
        // Failed to parse, treat as relative
        path = url;
      }
    } else {
      // Relative URL
      path = url;
    }

    // Ensure path starts with /
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    // Build normalized URL
    final normalized = '$baseUrl$path${query != null ? '?$query' : ''}';
    
    developer.log('ImageUrlHelper: Normalized URL: $normalized', name: 'ImageUrlHelper');
    return normalized;
  }
}

