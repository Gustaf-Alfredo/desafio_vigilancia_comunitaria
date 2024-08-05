class User {
  final int id;
  final String name;
  final String email;
  final bool isEmailVerified;
  final bool isAnonymous;
  final String photoURL;
  final String phoneNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isEmailVerified,
    required this.isAnonymous,
    required this.photoURL,
    required this.phoneNumber,
  });

    // Método para deserialização JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      isEmailVerified: json['isEmailVerified'] as bool,
      isAnonymous: json['isAnonymous'] as bool,
      photoURL: json['photoURL'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

 // Método para serialização JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'isAnonymous': isAnonymous,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
    };
  }
}
