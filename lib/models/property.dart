import 'package:hello_world/models/location.dart';
import 'package:hello_world/models/property_image.dart';
import 'booking.dart';

class Property {
  final int id;
  final String title;
  final String rooms;
  final String address;
  final String area;
  final String? userId;
  final String about;
  final String propertyTypeId;
  final kLocation? location;
  final String? price;
  final Image? image;
  bool? isFav;
  final List<HomeFacility>? homeFacilities;
  final User? user;
  final PropertyType? propertyType;
  final List<Image>? images;
  final List<Booking>? bookings;

  Property({
    required this.id,
    required this.title,
    required this.rooms,
    required this.address,
    required this.area,
    this.userId,
    required this.about,
    required this.propertyTypeId,
    this.image,
    this.location,
    this.price,
    this.homeFacilities,
    this.user,
    this.propertyType,
    this.images,
    this.isFav,
    this.bookings,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    final id = json["id"] as int? ?? 0;
    final title = json["title"] as String? ?? '';
    final rooms = json["rooms"] as String? ?? '';
    final address = json["address"] as String? ?? '';
    final area = json["area"] as String? ?? '';
    final isFav = json["is_fav"] as bool? ?? false;
    final userId = json["user_id"]?.toString();
    final about = json["about"] as String? ?? '';
    final propertyTypeId = json["property_type_id"]?.toString() ?? '';
    final price = json["price"]?.toString();
    final location =
        json["location"] != null ? kLocation.fromJson(json["location"]) : null;
    final image = json["image"] != null
        ? Image.fromJson(json["image"] as Map<String, dynamic>)
        : null;
    final homeFacilities = json["home_facilities"] != null
        ? (json["home_facilities"] as List)
            .map((i) => HomeFacility.fromJson(i as Map<String, dynamic>))
            .toList()
        : null;
    final user = json["user"] != null
        ? User.fromJson(json["user"] as Map<String, dynamic>)
        : null;
    final propertyType = json["property_type"] != null
        ? PropertyType.fromJson(json["property_type"] as Map<String, dynamic>)
        : null;
    final images = json["images"] != null
        ? (json["images"] as List)
            .map((i) => Image.fromJson(i as Map<String, dynamic>))
            .toList()
        : null;
    final bookings = json["bookings"] != null
        ? (json["bookings"] as List)
            .map((i) => Booking.fromJson(i as Map<String, dynamic>))
            .toList()
        : null;

    return Property(
      location: location,
      id: id,
      title: title,
      rooms: rooms,
      address: address,
      area: area,
      isFav: isFav,
      userId: userId,
      about: about,
      propertyTypeId: propertyTypeId,
      price: price,
      image: image,
      homeFacilities: homeFacilities,
      user: user,
      propertyType: propertyType,
      images: images,
      bookings: bookings,
    );
  }

  @override
  String toString() {
    return 'Property(id: $id, title: $title, rooms: $rooms, address: $address, area: $area, userId: $userId, about: $about, propertyTypeId: $propertyTypeId, location: $location, price: $price, image: $image, isFav: $isFav, homeFacilities: $homeFacilities, user: $user, propertyType: $propertyType, images: $images, bookings: $bookings)';
  }
}

class HomeFacility {
  final int id;
  final HomeFacilityDetail facility;

  HomeFacility({
    required this.id,
    required this.facility,
  });

  factory HomeFacility.fromJson(Map<String, dynamic> json) => HomeFacility(
        id: json["id"] as int,
        facility: json["home_facility"] != null
            ? HomeFacilityDetail.fromJson(
                json["home_facility"] as Map<String, dynamic>)
            : HomeFacilityDetail(id: 0, facility: ''),
      );

  @override
  String toString() {
    return 'HomeFacility{id: $id, facility: $facility}';
  }
}

class HomeFacilityDetail {
  final int id;
  final String facility;

  HomeFacilityDetail({
    required this.id,
    required this.facility,
  });

  factory HomeFacilityDetail.fromJson(Map<String, dynamic> json) =>
      HomeFacilityDetail(
        id: json["id"] as int? ?? 0,
        facility: json["facility"] as String? ?? '',
      );

  @override
  String toString() {
    return 'HomeFacilityDetail{id: $id, facility: $facility}';
  }
}

class User {
  final int? id;
  final String? name;
  final String? userType;
  final String? google_id;
  final String? email;

  User({
    this.id,
    this.name,
    this.userType,
    this.google_id,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"] as int? ?? 0,
      name: json["name"] as String? ?? '',
      userType: json["userType"] as String? ?? '',
      google_id: json["google_id"] as String? ?? '',
      email: json["email"] as String? ?? '');

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "userType": userType,
        "google_id": google_id,
        "email": email
      };

  @override
  String toString() {
    return 'User(id: $id, name: $name, userType: $userType, google_id: $google_id, email: $email)';
  }
}

class PropertyType {
  final int id;
  final String propertyType;
  final String color;

  PropertyType(
      {required this.id, required this.propertyType, required this.color});

  factory PropertyType.fromJson(Map<String, dynamic> json) {
    return PropertyType(
      id: json["id"] as int? ?? 0, // Default to 0 if null
      propertyType: json["property_type"] as String? ??
          '', // Default to empty string if null
      color: json["color"] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "property_type": propertyType,
      };

  @override
  String toString() {
    return 'PropertyType(id: $id, propertyType: $propertyType, color: $color)';
  }
}
