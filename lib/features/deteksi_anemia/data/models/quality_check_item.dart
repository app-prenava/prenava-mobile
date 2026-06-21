/// Quality Check Item Model
/// 
/// Represents a single quality check criterion for anemia detection photo.
/// Used in QualityCheckDialog to display requirements for quality photo capture.
class QualityCheckItem {
  /// Unique identifier for the quality check item
  final int id;
  
  /// Display label/title for the criterion
  final String label;
  
  /// Detailed description of the criterion
  final String description;

  const QualityCheckItem({
    required this.id,
    required this.label,
    required this.description,
  });

  /// Factory constructor to generate 5 default quality check items
  /// 
  /// Returns an immutable list of 5 quality criteria items as specified in design.
  static List<QualityCheckItem> getDefaultItems() {
    return const [
      QualityCheckItem(
        id: 1,
        label: 'Konjungtiva Jelas',
        description: 'Area konjungtiva terlihat dengan jelas dan utuh',
      ),
      QualityCheckItem(
        id: 2,
        label: 'Pencahayaan Baik',
        description: 'Pencahayaan cukup terang, tidak ada bayangan',
      ),
      QualityCheckItem(
        id: 3,
        label: 'Mata Terbuka',
        description: 'Mata dalam posisi terbuka lebar',
      ),
      QualityCheckItem(
        id: 4,
        label: 'No Filter',
        description: 'Tidak ada filter atau efek pada kamera',
      ),
      QualityCheckItem(
        id: 5,
        label: 'Tidak Ada Penghalang',
        description: 'Tidak ada penghalang (rambut, tangan) di depan mata',
      ),
    ];
  }

  @override
  String toString() => 'QualityCheckItem(id: $id, label: $label)';
}
