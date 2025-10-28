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
  
  File? _selectedImage;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;
    
    if (_isEditing) {
      _productNameController.text = widget.product!.productName;
      _priceController.text = widget.product!.price;
      _urlController.text = widget.product!.url;
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
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

      // Check file size (max 500KB)
      if (fileSize > 500 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ukuran foto maksimal 500KB'),
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

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate photo for create
    if (!_isEditing && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto produk wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = {
      'product_name': _productNameController.text.trim(),
      'price': _priceController.text.trim().replaceAll('.', ''),
      'url': _urlController.text.trim(),
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
            backgroundColor: Colors.green,
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
        title: Text(_isEditing ? 'Edit Produk' : 'Tambah Produk'),
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Upload
              Center(
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : _isEditing && widget.product!.photo != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  widget.product!.photo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildPlaceholder();
                                  },
                                ),
                              )
                            : _buildPlaceholder(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: _showImageSourceDialog,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(_selectedImage == null ? 'Pilih Foto' : 'Ganti Foto'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFFA6978),
                  ),
                ),
              ),
              if (_selectedImage == null && !_isEditing)
                Center(
                  child: Text(
                    '*Foto wajib diisi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[700],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Product Name
              const Text(
                'Nama Produk *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama produk wajib diisi';
                  }
                  if (value.length > 255) {
                    return 'Nama produk maksimal 255 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price
              const Text(
                'Harga *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan harga',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  if (value.length > 50) {
                    return 'Harga maksimal 50 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // URL
              const Text(
                'Link Produk *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: 'https://...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Link produk wajib diisi';
                  }
                  if (!value.startsWith('http://') && !value.startsWith('https://')) {
                    return 'Link harus diawali dengan http:// atau https://';
                  }
                  if (value.length > 2048) {
                    return 'Link maksimal 2048 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: shopState.isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA6978),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: shopState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate,
          size: 60,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 8),
        Text(
          'Tambah Foto',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          'Max 500KB',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}

