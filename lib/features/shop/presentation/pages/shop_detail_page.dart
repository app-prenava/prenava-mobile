import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/shop_providers.dart';

class ShopDetailPage extends ConsumerStatefulWidget {
  final String productId;

  const ShopDetailPage({super.key, required this.productId});

  @override
  ConsumerState<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends ConsumerState<ShopDetailPage> {
  int _currentRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmittingReview = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopNotifierProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState.user?.id;

    final allProducts = shopState.products;

    if (shopState.isLoading && allProducts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Produk'),
          backgroundColor: const Color(0xFFFA6978),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final productIndex = allProducts.indexWhere(
      (p) => p.productId.toString() == widget.productId,
    );

    if (productIndex == -1) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Produk Tidak Ditemukan'),
          backgroundColor: const Color(0xFFFA6978),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Produk tidak ditemukan'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA6978),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }

    final product = allProducts[productIndex];
    final isMyProduct = product.userId == currentUserId;
    final reviewsAsync =
        ref.watch(productReviewsProvider(product.productId ?? 0));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: product.photo != null && product.photo!.isNotEmpty
                      ? Image.network(
                          product.photo!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 100,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                ),

                // Details
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        product.productName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Rating summary
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 20,
                            color: product.ratingCount > 0
                                ? Colors.amber
                                : Colors.grey[400],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            product.ratingCount > 0
                                ? product.averageRating.toStringAsFixed(1)
                                : 'Belum ada rating',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (product.ratingCount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '(${product.ratingCount} review)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Harga',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Rp ${product.price}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFA6978),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Seller info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isMyProduct
                              ? const Color(0xFFE3F2FD)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isMyProduct
                                ? const Color(0xFF42A5F5)
                                : Colors.grey[200]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isMyProduct
                                  ? const Color(0xFF42A5F5)
                                  : const Color(0xFFFFB6C1),
                              radius: 24,
                              child: Icon(
                                isMyProduct ? Icons.person : Icons.store,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isMyProduct
                                        ? 'Produk Saya'
                                        : (product.sellerName ??
                                            'Produk Komunitas'),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isMyProduct
                                          ? const Color(0xFF1976D2)
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isMyProduct
                                        ? 'Anda adalah penjual'
                                        : 'Penjual',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isMyProduct)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF42A5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'MILIK SAYA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (product.description?.isNotEmpty ?? false)
                            ? product.description!
                            : '-',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Reviews list
                      _buildReviewsSection(
                        reviewsAsync,
                        currentUserId,
                        product.productId ?? 0,
                      ),

                      const SizedBox(height: 24),

                      // Review form
                      _buildReviewForm(product.productId ?? 0),

                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Keranjang'),
                                    content: const Text(
                                        'Fitur keranjang akan segera hadir!'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color(0xFFFA6978)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Keranjang',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFA6978),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () => _launchUrl(product.url),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFA6978),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Beli Sekarang',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Back + actions
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: favorite
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // TODO: share
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.share,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(
    AsyncValue<List<dynamic>> reviewsAsync,
    int? currentUserId,
    int productId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ulasan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        reviewsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                color: Color(0xFFFA6978),
              ),
            ),
          ),
          error: (e, _) => Text(
            'Gagal memuat ulasan: ${e.toString().replaceAll('Exception: ', '')}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.red[400],
            ),
          ),
          data: (reviews) {
            if (reviews.isEmpty) {
              return Text(
                'Belum ada ulasan. Jadilah yang pertama memberikan review!',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final review = reviews[index];
                final isMine =
                    currentUserId != null && review.userId == currentUserId;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                const Color(0xFFFA6978).withOpacity(0.15),
                            child: const Icon(
                              Icons.person,
                              size: 18,
                              color: Color(0xFFFA6978),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.userName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < review.rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 14,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          if (isMine)
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                              onPressed: () =>
                                  _deleteReview(review.id, productId),
                            ),
                        ],
                      ),
                      if (review.comment != null &&
                          review.comment!.trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          review.comment!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildReviewForm(int productId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Beri Ulasan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isSelected = _currentRating >= starIndex;
            return IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                isSelected ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _currentRating = starIndex;
                });
              },
            );
          }),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _reviewController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Bagikan pengalamanmu dengan produk ini...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed:
                _isSubmittingReview ? null : () => _submitReview(productId),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA6978),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: _isSubmittingReview
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Kirim',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitReview(int productId) async {
    if (_currentRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih rating terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmittingReview = true;
    });

    try {
      final repository = ref.read(shopRepositoryProvider);
      await repository.upsertReview(
        productId: productId,
        rating: _currentRating,
        comment: _reviewController.text.trim(),
      );

      ref.invalidate(productReviewsProvider(productId));
      await ref.read(shopNotifierProvider.notifier).refreshProducts();

      _reviewController.clear();
      setState(() {
        _currentRating = 0;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review berhasil dikirim'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengirim review: ${e.toString().replaceAll('Exception: ', '')}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingReview = false;
        });
      }
    }
  }

  Future<void> _deleteReview(int reviewId, int productId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Ulasan'),
        content: const Text('Apakah kamu yakin ingin menghapus ulasan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Color(0xFFFA6978)),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    try {
      final repository = ref.read(shopRepositoryProvider);
      await repository.deleteReview(productId: productId, reviewId: reviewId);

      ref.invalidate(productReviewsProvider(productId));
      await ref.read(shopNotifierProvider.notifier).refreshProducts();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ulasan berhasil dihapus'),
          backgroundColor: Color(0xFFFA6978),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menghapus ulasan: ${e.toString().replaceAll('Exception: ', '')}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

