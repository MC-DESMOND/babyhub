class JwtResponse {
  final String accessToken;
  final String tokenType;
  final int id;
  final String email;
  final String name;

  JwtResponse({
    required this.accessToken,
    required this.tokenType,
    required this.id,
    required this.email,
    required this.name,
  });

  factory JwtResponse.fromJson(Map<String, dynamic> json) {
    return JwtResponse(
      accessToken: json['accessToken'],
      tokenType: json['tokenType'],
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}