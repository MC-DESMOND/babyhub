class JwtResponse {
  final String token;
  final String type;
  final int id;
  final String email;
  final String name;

  JwtResponse({
    required this.token,
    required this.type,
    required this.id,
    required this.email,
    required this.name,
  });

  factory JwtResponse.fromJson(Map<String, dynamic> json) {
    return JwtResponse(
      token: json['token'],
      type: json['type'],
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}