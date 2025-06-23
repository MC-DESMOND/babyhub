class User {
  final int id;
  final String name;
  final String email;
  final String? password; // Nullable for response, required for creation

  User({required this.id, required this.name, required this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'], // Might not be sent back from backend
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'email': email,
    };
    if (password != null) {
      data['password'] = password;
    }
    return data;
  }
}