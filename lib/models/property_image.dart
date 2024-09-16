class Image {
  final int? id;
  final int? propId;
  final String? imagePath;

  Image({
    this.id,
    this.propId,
    this.imagePath,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"] as int? ?? 0, // Default to 0 if null
        propId: json["prop_id"] as int? ?? 0, // Default to 0 if null
        imagePath: json["image_path"] as String? ??
            '', // Default to empty string if null
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prop_id": propId,
        "image_path": imagePath,
      };

  @override
  String toString() {
    return 'Image(id: $id, propId: $propId, imagePath: $imagePath)';
  }
}
