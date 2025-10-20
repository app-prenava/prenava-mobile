class ProductModel {
  final int? id;
  final String produk;
  final String deskripsi;
  final double harga;
  final String? gambar;
  final String? link;
  final String? createdAt;
  final String? updatedAt;

  const ProductModel({
    this.id,
    required this.produk,
    required this.deskripsi,
    required this.harga,
    this.gambar,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double parsedHarga;
    final dynamic hargaValue = json['harga'];
    if (hargaValue is String) {
      parsedHarga = double.tryParse(hargaValue) ?? 0.0;
    } else if (hargaValue is num) {
      parsedHarga = hargaValue.toDouble();
    } else {
      parsedHarga = 0.0;
    }

    return ProductModel(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'] as int?,
      produk: (json['produk'] as String?)?.trim() ?? '',
      deskripsi: (json['deskripsi'] as String?)?.trim() ?? '',
      harga: parsedHarga,
      gambar: json['gambar'] as String?,
      link: json['link'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
