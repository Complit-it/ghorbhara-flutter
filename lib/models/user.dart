// class User {
//   int? id;
//   String? name;
//   String? email;
//   String? token;
//   // String? name;

//   User({this.id, this.name, this.email, this.token});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['user']['id'],
//       name: json['user']['name'],
//       email: json['user']['email'],
//       token: json['user']['token'],
//     );
//   }
// }

class User {
  int? id;
  String? name;
  String? email;
  String? token;
  String? phone;
  String? userType;
  String? google_id;
  String? imageUrl;

  User(
      {this.id,
      this.name,
      this.email,
      this.token,
      this.phone,
      this.userType,
      this.google_id,
      this.imageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['id'],
        name: json['user']['name'],
        email: json['user']['email'],
        phone: json['user']['phone'],
        userType: json['user']['userType'],
        google_id: json['user']['google_id'],
        token: json['token'],
        imageUrl: json['user']['photo_url']);
  }
  @override
  String toString() {
    // TODO: implement toString
    return 'User(id: $id, name: $name, email: $email, phone: $phone, userType: $userType, token: $token, google_id: $google_id, imageUrl: $imageUrl)';
  }
}
