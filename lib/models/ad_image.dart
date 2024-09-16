class AdImage {
  final int? id;
  final int? adId;
  final String? imagePath;
  final String? isMain;

  AdImage({
    this.id,
    this.adId,
    this.imagePath,
    this.isMain,
  });

  factory AdImage.fromJson(Map<String, dynamic> json) {
    return AdImage(
      id: json['id'] as int? ?? 0,
      adId: json['ad_id'] as int? ?? 0,
      imagePath: json['image_path'] as String? ?? '',
      isMain: json['is_main'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad_id': adId,
      'image_path': imagePath,
      'is_main': isMain,
    };
  }

  @override
  String toString() {
    return 'AdImage(id: $id, adId: $adId, imagePath: $imagePath, isMain: $isMain)';
  }
}
