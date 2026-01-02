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
  /// - Full URLs from Supabase S3 (preserves as-is)
  /// - Full URLs from other CDNs (preserves as-is)
  /// - Relative URLs (e.g., /storage/file.jpg or storage/file.jpg)
  /// - localhost URLs (replaces with correct base URL)
  static String? normalizeImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      developer.log('ImageUrlHelper: URL is null or empty', name: 'ImageUrlHelper');
      return null;
    }

    developer.log('ImageUrlHelper: Original URL: $url', name: 'ImageUrlHelper');

    // If it's already a full URL, check if it's from Supabase or external CDN
    if (url.startsWith('http://') || url.startsWith('https://')) {
      final uri = Uri.tryParse(url);
      if (uri != null && uri.host.isNotEmpty) {
        // Check if it's a Supabase storage URL
        if (uri.host.contains('.storage.supabase.co') ||
            uri.host.contains('supabase.co')) {
          developer.log('ImageUrlHelper: Detected Supabase URL, preserving as-is', name: 'ImageUrlHelper');
          return url;
        }

        // Check if it's from an external CDN/storage service (not our API domain)
        final baseUrl = _baseUrl;
        final baseUrlUri = Uri.tryParse(baseUrl);
        if (baseUrlUri != null && uri.host != baseUrlUri.host) {
          // It's a full URL from a different domain - preserve it
          developer.log('ImageUrlHelper: External CDN URL detected, preserving: $url', name: 'ImageUrlHelper');
          return url;
        }

        developer.log('ImageUrlHelper: Full URL from our domain, will normalize', name: 'ImageUrlHelper');
      }
    }

    // For relative URLs or URLs from our API domain, normalize with base URL
    final baseUrl = _baseUrl;
    developer.log('ImageUrlHelper: Base URL: $baseUrl', name: 'ImageUrlHelper');

    // Parse the URL to extract the path
    String path;
    String? query;

    if (url.startsWith('http://') || url.startsWith('https://')) {
      final uri = Uri.tryParse(url);
      if (uri != null) {
        path = uri.path;
        query = uri.query.isNotEmpty ? uri.query : null;
        developer.log('ImageUrlHelper: Extracted path from full URL: $path', name: 'ImageUrlHelper');
      } else {
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

