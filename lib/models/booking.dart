import 'property.dart';

class Booking {
  final String? propId;
  final String? userId;
  final String? bookingDate;
  final User? user;

  Booking({
    this.propId,
    this.userId,
    this.bookingDate,
    this.user,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    final propId = json["prop_id"]?.toString();
    final userId = json["user_id"]?.toString();
    final bookingDate = json["booking_date"]?.toString();
    final user = json["user"] != null
        ? User.fromJson(json["user"] as Map<String, dynamic>)
        : null;

    return Booking(
      propId: propId,
      userId: userId,
      bookingDate: bookingDate,
      user: user,
    );
  }

  @override
  String toString() {
    return 'Booking(propId: $propId, userId: $userId, bookingDate: $bookingDate, user: $user)';
  }
}
