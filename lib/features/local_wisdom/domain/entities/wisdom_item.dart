class WisdomItem {
  final int id;
  final String myth;
  final String reason;
  final String region;
  final bool isChecked;

  const WisdomItem({
    required this.id,
    required this.myth,
    required this.reason,
    required this.region,
    this.isChecked = false,
  });

  WisdomItem copyWith({bool? isChecked}) {
    return WisdomItem(
      id: id,
      myth: myth,
      reason: reason,
      region: region,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WisdomItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
