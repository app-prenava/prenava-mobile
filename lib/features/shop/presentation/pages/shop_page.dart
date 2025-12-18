import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/shop_providers.dart';

class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String?>> _categories = const [
    {'label': 'All', 'slug': null},
    {'label': 'Vitamin', 'slug': 'vitamin'},
    {'label': 'Makanan', 'slug': 'makanan'},
    {'label': 'Peralatan Bayi', 'slug': 'peralatan_bayi'},
    {'label': 'Kesehatan', 'slug': 'kesehatan'},
    {'label': 'Lainnya', 'slug': 'lainnya'},
  ];
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      final slug = _categories[_selectedCategory]['slug'];
      ref.read(shopNotifierProvider.notifier).loadProducts(loadMore: true, category: slug);
    }
  }

  void _onSearchChanged(String query) {
    ref.read(shopNotifierProvider.notifier).filterProducts(query);
  }

  void _onCategoryChanged(int index) {
    setState(() => _selectedCategory = index);
    final slug = _categories[index]['slug'];
    ref.read(shopNotifierProvider.notifier).loadProducts(category: slug);
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFFFA6978),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belanja',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Hari ini mau beli apa momsi?',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Cari Produk',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFFA6978)),
                ),
              ),
            ),
          ),

          // Categories tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final bool active = _selectedCategory == index;
                  return GestureDetector(
                    onTap: () => _onCategoryChanged(index),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _categories[index]['label']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            color: active ? const Color(0xFFFA6978) : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 3,
                          width: 24,
                          decoration: BoxDecoration(
                            color: active ? const Color(0xFFFA6978) : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Products Grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(shopNotifierProvider.notifier).loadProducts(category: _categories[_selectedCategory]['slug']),
              child: shopState.isLoading && shopState.products.isEmpty
                  ? ListView(
                      // Supaya RefreshIndicator tetap bisa di-swipe
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    )
                  : shopState.displayProducts.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 40),
                            _buildEmptyState(context),
                          ],
                        )
                      : GridView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.62,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: shopState.displayProducts.length +
                              (shopState.hasMore && shopState.searchQuery.isEmpty ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == shopState.displayProducts.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final product = shopState.displayProducts[index];
                            return _buildProductCard(product);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(product) {
    return GestureDetector(
      onTap: () => context.push('/shop/detail/${product.productId}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 1,
                child: product.photo != null && product.photo!.isNotEmpty
                    ? Image.network(
                        product.photo!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: const Color(0xFFFA6978),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Image load error for: ${product.photo}');
                          debugPrint('Error: $error');
                          return Container(
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                const SizedBox(height: 4),
                                Text(
                                  'Failed to load',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Rating row
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: product.ratingCount > 0
                            ? Colors.amber
                            : Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.ratingCount > 0
                            ? (product.averageRating)
                                .toStringAsFixed(1)
                            : 'Belum ada rating',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (product.ratingCount > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(${product.ratingCount})',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'Rp ${product.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFA6978),
                    ),
                  ),
                ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
                  Text(
            'Belum ada produk',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
            'Mulai tambahkan produk untuk dijual',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/shop/add'),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Produk'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFA6978),
                            foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
