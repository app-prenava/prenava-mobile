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
  final List<String> _categories = const [
    'All',
    'Vitamin',
    'Makanan',
    'Peralatan Bayi',
    'Kesehatan',
    'Ibu Hamil'
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
      ref.read(shopNotifierProvider.notifier).loadProducts(loadMore: true);
    }
  }

  void _onSearchChanged(String query) {
    ref.read(shopNotifierProvider.notifier).filterProducts(query);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Belanja',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hari ini mau beli apa momsi?',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Search
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

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
                    onTap: () => setState(() => _selectedCategory = index),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _categories[index],
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
              onRefresh: () => ref.read(shopNotifierProvider.notifier).refreshProducts(),
              child: shopState.isLoading && shopState.products.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : shopState.displayProducts.isEmpty
                      ? _buildEmptyState()
                      : GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: shopState.displayProducts.length + (shopState.hasMore && shopState.searchQuery.isEmpty ? 1 : 0),
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
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
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
                    const Spacer(),
                  Text(
                      'Rp ${product.price}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      color: Color(0xFFFA6978),
                      ),
                    ),
                    if (product.sellerName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        product.sellerName!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
