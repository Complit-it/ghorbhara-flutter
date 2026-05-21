import 'package:hello_world/models/property.dart' as prop;
import 'package:hello_world/models/user.dart';
import 'package:hello_world/models/booking.dart';
import 'package:hello_world/models/location.dart';

class DummyData {
  static final List<User> dummyUsers = [
    User(
      id: 1,
      name: 'John Owner',
      email: 'owner@example.com',
      phone: '+919876543210',
      userType: 'owner',
      google_id: 'owner_google_123',
      imageUrl: 'https://via.placeholder.com/150?text=John+Owner',
      token: 'demo_token_owner_1',
    ),
    User(
      id: 2,
      name: 'Jane Tenant',
      email: 'tenant@example.com',
      phone: '+919123456789',
      userType: 'tenant',
      google_id: 'tenant_google_456',
      imageUrl: 'https://via.placeholder.com/150?text=Jane+Tenant',
      token: 'demo_token_tenant_1',
    ),
    User(
      id: 3,
      name: 'Mike Property',
      email: 'mike.property@example.com',
      phone: '+918765432109',
      userType: 'owner',
      google_id: 'owner_google_789',
      imageUrl: 'https://via.placeholder.com/150?text=Mike+Property',
      token: 'demo_token_owner_2',
    ),
    User(
      id: 4,
      name: 'Sarah Finder',
      email: 'sarah.finder@example.com',
      phone: '+917654321098',
      userType: 'tenant',
      google_id: 'tenant_google_101',
      imageUrl: 'https://via.placeholder.com/150?text=Sarah+Finder',
      token: 'demo_token_tenant_2',
    ),
  ];

  static final List<prop.Property> dummyProperties = [
    prop.Property(
      id: 1,
      title: 'Luxury Apartment in Downtown',
      rooms: '3',
      address: '123 Main Street, City Center',
      area: '1200',
      userId: '1',
      about: 'Beautiful 3BHK apartment with modern amenities, gym, and swimming pool access.',
      propertyTypeId: '1',
      price: '50000',
      location: kLocation(lat: '28.6139', long: '77.2090', location: 'City Center, Delhi'),
      isFav: false,
      homeFacilities: [
        prop.HomeFacility(id: 1, facility: prop.HomeFacilityDetail(id: 1, facility: 'WiFi')),
        prop.HomeFacility(id: 2, facility: prop.HomeFacilityDetail(id: 2, facility: 'Parking')),
        prop.HomeFacility(id: 3, facility: prop.HomeFacilityDetail(id: 3, facility: 'AC')),
        prop.HomeFacility(id: 4, facility: prop.HomeFacilityDetail(id: 4, facility: 'Balcony')),
      ],
      images: const [],
    ),
    prop.Property(
      id: 2,
      title: 'Cozy Studio Near Metro',
      rooms: '1',
      address: '456 Park Avenue, Suburb',
      area: '550',
      userId: '1',
      about: 'Studio apartment perfect for professionals, near metro station and shopping mall.',
      propertyTypeId: '2',
      price: '25000',
      location: kLocation(lat: '28.5244', long: '77.1855', location: 'Suburb, Delhi'),
      isFav: false,
      homeFacilities: [
        prop.HomeFacility(id: 1, facility: prop.HomeFacilityDetail(id: 1, facility: 'WiFi')),
        prop.HomeFacility(id: 5, facility: prop.HomeFacilityDetail(id: 5, facility: 'Furnished')),
      ],
      images: const [],
    ),
    prop.Property(
      id: 3,
      title: 'Spacious Villa with Garden',
      rooms: '4',
      address: '789 Green Lane, Residential Area',
      area: '2500',
      userId: '3',
      about: 'Spacious 4BHK villa with private garden, play area, and servant quarter.',
      propertyTypeId: '3',
      price: '80000',
      location: kLocation(lat: '28.4595', long: '77.0266', location: 'Residential Area, Delhi'),
      isFav: false,
      homeFacilities: [
        prop.HomeFacility(id: 1, facility: prop.HomeFacilityDetail(id: 1, facility: 'WiFi')),
        prop.HomeFacility(id: 2, facility: prop.HomeFacilityDetail(id: 2, facility: 'Parking')),
        prop.HomeFacility(id: 3, facility: prop.HomeFacilityDetail(id: 3, facility: 'AC')),
        prop.HomeFacility(id: 6, facility: prop.HomeFacilityDetail(id: 6, facility: 'Garden')),
        prop.HomeFacility(id: 7, facility: prop.HomeFacilityDetail(id: 7, facility: 'Gym')),
      ],
      images: const [],
    ),
    prop.Property(
      id: 4,
      title: 'Modern 2BHK Flat',
      rooms: '2',
      address: '321 Tech Park, IT District',
      area: '900',
      userId: '3',
      about: 'Modern 2BHK apartment with fully equipped kitchen, in a gated community.',
      propertyTypeId: '1',
      price: '35000',
      location: kLocation(lat: '28.5355', long: '77.3910', location: 'IT District, Delhi'),
      isFav: false,
      homeFacilities: [
        prop.HomeFacility(id: 1, facility: prop.HomeFacilityDetail(id: 1, facility: 'WiFi')),
        prop.HomeFacility(id: 2, facility: prop.HomeFacilityDetail(id: 2, facility: 'Parking')),
        prop.HomeFacility(id: 3, facility: prop.HomeFacilityDetail(id: 3, facility: 'AC')),
        prop.HomeFacility(id: 8, facility: prop.HomeFacilityDetail(id: 8, facility: 'Security')),
      ],
      images: const [],
    ),
    prop.Property(
      id: 5,
      title: 'Budget-Friendly Room Share',
      rooms: '1',
      address: '555 College Road, University Area',
      area: '400',
      userId: '1',
      about: 'Single room in a shared apartment, perfect for students and professionals.',
      propertyTypeId: '4',
      price: '15000',
      location: kLocation(lat: '28.5921', long: '77.2710', location: 'University Area, Delhi'),
      isFav: false,
      homeFacilities: [
        prop.HomeFacility(id: 1, facility: prop.HomeFacilityDetail(id: 1, facility: 'WiFi')),
        prop.HomeFacility(id: 5, facility: prop.HomeFacilityDetail(id: 5, facility: 'Furnished')),
      ],
      images: const [],
    ),
    prop.Property(
      id: 6,
      title: 'Family Home in Quiet Neighbourhood',
      rooms: '3',
      address: '88 Serene Street, Green Park',
      area: '1600',
      userId: '3',
      about: 'Comfortable 3BHK family home in a peaceful neighbourhood with parks nearby.',
      propertyTypeId: '1',
      price: '42000',
      location: kLocation(lat: '28.5600', long: '77.2000', location: 'Green Park, Delhi'),
      isFav: false,
      homeFacilities: [
        prop.HomeFacility(id: 1, facility: prop.HomeFacilityDetail(id: 1, facility: 'WiFi')),
        prop.HomeFacility(id: 2, facility: prop.HomeFacilityDetail(id: 2, facility: 'Parking')),
        prop.HomeFacility(id: 6, facility: prop.HomeFacilityDetail(id: 6, facility: 'Garden')),
      ],
      images: const [],
    ),
  ];

  static final List<Booking> dummyBookings = [
    Booking(
      propId: '1',
      userId: '2',
      bookingDate: '2025-01-01',
    ),
    Booking(
      propId: '3',
      userId: '4',
      bookingDate: '2025-01-15',
    ),
  ];

  static List<prop.Property> searchProperties(String query) {
    return dummyProperties
        .where((property) =>
            property.title.toLowerCase().contains(query.toLowerCase()) ||
            property.address.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static List<prop.Property> filterProperties({
    String? priceRange,
    String? rooms,
    String? propertyType,
  }) {
    return dummyProperties.where((property) {
      bool matches = true;
      if (rooms != null && rooms.isNotEmpty) {
        matches = matches && property.rooms == rooms;
      }
      return matches;
    }).toList();
  }

  static const Map<int, double> propertyDistances = {
    1: 2.3,
    2: 5.1,
    3: 12.4,
    4: 8.7,
    5: 3.6,
    6: 7.2,
  };

  static String getDistanceLabel(int propertyId) {
    final d = propertyDistances[propertyId];
    if (d == null) return '';
    return d < 1 ? '${(d * 1000).round()} m away' : '${d.toStringAsFixed(1)} km away';
  }

  static const Map<int, List<String>> propertyImages = {
    1: [
      'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&h=500&fit=crop&q=80',
      'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800&h=500&fit=crop&q=80',
      'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&h=500&fit=crop&q=80',
    ],
    2: [
      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&h=500&fit=crop&q=80',
      'https://images.unsplash.com/photo-1560185127-6a4a40b56ab2?w=800&h=500&fit=crop&q=80',
    ],
    3: [
      'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800&h=500&fit=crop&q=80',
      'https://images.unsplash.com/photo-1416331108676-a22ccb276e35?w=800&h=500&fit=crop&q=80',
      'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800&h=500&fit=crop&q=80',
    ],
    4: [
      'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800&h=500&fit=crop&q=80',
      'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?w=800&h=500&fit=crop&q=80',
    ],
    5: [
      'https://images.unsplash.com/photo-1586105251261-72a756497a11?w=800&h=500&fit=crop&q=80',
    ],
    6: [
      'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800&h=500&fit=crop&q=80',
      'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800&h=500&fit=crop&q=80',
    ],
  };

  static List<String> getPropertyImages(int propertyId) {
    return propertyImages[propertyId] ??
        ['https://picsum.photos/seed/default$propertyId/800/500'];
  }

  static prop.Property? getPropertyById(int id) {
    try {
      return dummyProperties.firstWhere((property) => property.id == id);
    } catch (e) {
      return null;
    }
  }

  static User? getUserById(int id) {
    try {
      return dummyUsers.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Booking> getUserBookings(int userId) {
    return dummyBookings
        .where((booking) => booking.userId == userId.toString())
        .toList();
  }

  static List<Booking> getPropertyBookings(int propertyId) {
    return dummyBookings
        .where((booking) => booking.propId == propertyId.toString())
        .toList();
  }
}
