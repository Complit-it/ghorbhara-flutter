import 'ad_image.dart';

class Ad {
  final int id;
  final String title;
  final String? desc;
  final String? subDesc;
  final AdImage? image;
  final List<AdImage>? allImages;

  Ad({
    required this.id,
    required this.title,
    this.desc,
    this.subDesc,
    this.image,
    this.allImages,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'] as int,
      title: json['title'] as String,
      desc: json['desc'] as String? ?? '',
      subDesc: json['sub_desc'] as String? ?? '',
      image: json['main_image'] != null
          ? AdImage.fromJson(json['main_image'] as Map<String, dynamic>)
          : null,
      allImages: json['all_images'] != null
          ? (json['all_images'] as List)
              .map((i) => AdImage.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'sub_desc': subDesc,
      'main_image': image?.toJson(),
      'all_images': allImages?.map((i) => i.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Ad(id: $id, title: $title, desc: $desc, subDesc: $subDesc, image: $image, allImages: $allImages)';
  }
}
