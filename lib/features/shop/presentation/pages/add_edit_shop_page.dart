import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/product.dart';
import '../providers/shop_providers.dart';

class AddEditShopPage extends ConsumerStatefulWidget {
  final Product? product;

  const AddEditShopPage({super.key, this.product});

  @override
  ConsumerState<AddEditShopPage> createState() => _AddEditShopPageState();
}

class _AddEditShopPageState extends ConsumerState<AddEditShopPage> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _urlController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedImage;
  bool _isEditing = false;
  String? _selectedCategorySlug;

  static const List<Map<String, String>> _categories = [
    {'label': 'Vitamin', 'slug': 'vitamin'},
    {'label': 'Makanan', 'slug': 'makanan'},
    {'label': 'Peralatan Bayi', 'slug': 'peralatan_bayi'},
    {'label': 'Kesehatan', 'slug': 'kesehatan'},
    {'label': 'Lainnya', 'slug': 'lainnya'},
  ];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;

    if (_isEditing) {
      _productNameController.text = widget.product!.productName;
      _priceController.text = widget.product!.price;
      _urlController.text = widget.product!.url;
      _descriptionController.text = widget.product!.description ?? '';
      _selectedCategorySlug = widget.product!.category;
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _urlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 500 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ukuran foto terlalu besar, maksimal 500KB'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() {
        _selectedImage = file;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate photo for create
    if (!_isEditing && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tambahkan foto produk terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = {
      'product_name': _productNameController.text.trim(),
      'price': _priceController.text.trim().replaceAll('.', ''),
      'url': _urlController.text.trim(),
      'description': _descriptionController.text.trim(),
      if (_selectedCategorySlug != null) 'category': _selectedCategorySlug,
    };

    bool success;
    if (_isEditing) {
      success = await ref.read(shopNotifierProvider.notifier).updateProduct(
            productId: widget.product!.productId!,
            data: data,
            photoPath: _selectedImage?.path,
          );
    } else {
      success = await ref.read(shopNotifierProvider.notifier).createProduct(
            data: data,
            photoPath: _selectedImage!.path,
          );
    }

    if (mounted) {
      final shopState = ref.read(shopNotifierProvider);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(shopState.successMessage ?? 'Berhasil'),
            backgroundColor: const Color(0xFFFA6978),
          ),
        );
        context.pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(shopState.error ?? 'Gagal menyimpan produk'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          _isEditing ? 'Edit Produk' : 'Tambah Produk',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Photo Area - Grab style (minimal, tappable)
            _buildPhotoArea(),

            const SizedBox(height: 24),

            // Product Name
            _buildTextField(
              controller: _productNameController,
              label: 'Nama Produk',
              hint: 'Masukkan nama produk',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama produk wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Price
            _buildTextField(
              controller: _priceController,
              label: 'Harga',
              hint: 'Contoh: 50000',
              keyboardType: TextInputType.number,
              prefixText: 'Rp ',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Harga wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Category Dropdown
            _buildCategoryDropdown(),

            const SizedBox(height: 20),

            // Description
            _buildTextField(
              controller: _descriptionController,
              label: 'Deskripsi',
              hint: 'Ceritakan produk secara singkat',
              maxLines: 4,
              alignLabelWithHint: true,
            ),

            const SizedBox(height: 20),

            // URL
            _buildTextField(
              controller: _urlController,
              label: 'Link Produk',
              hint: 'https://tokopedia.com/...',
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Link produk wajib diisi';
                }
                if (!value.startsWith('http://') &&
                    !value.startsWith('https://')) {
                  return 'Link harus diawali http:// atau https://';
                }
                return null;
              },
            ),

            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      // Sticky CTA - Grab style
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: shopState.isLoading ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFA6978),
            disabledBackgroundColor: Colors.grey[300],
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: shopState.isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(
                  _isEditing ? 'Simpan Perubahan' : 'Tambah Produk',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildPhotoArea() {
    final hasImage = _selectedImage != null ||
        (_isEditing && widget.product!.photo != null);

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: hasImage
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.product!.photo!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPhotoPlaceholder(),
                          ),
                  ),
                  // Edit overlay
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Ubah',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : _buildPhotoPlaceholder(),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo_outlined,
          size: 36,
          color: Colors.grey[500],
        ),
        const SizedBox(height: 8),
        Text(
          'Tambah foto produk',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? prefixText,
    int maxLines = 1,
    bool alignLabelWithHint = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        alignLabelWithHint: alignLabelWithHint,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 15,
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFA6978), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategorySlug,
      decoration: InputDecoration(
        labelText: 'Kategori',
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 15,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFA6978), width: 1.5),
        ),
      ),
      hint: Text(
        'Pilih kategori',
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
      ),
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
      items: _categories
          .map((c) => DropdownMenuItem(
                value: c['slug']!,
                child: Text(c['label']!),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategorySlug = value;
        });
      },
    );
  }
}
