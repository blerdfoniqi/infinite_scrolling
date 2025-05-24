class User {
  final String fullName;
  final String email;
  final String thumbnailUrl;
  final String largePictureUrl;
  final String city;
  final String country;
  final String countryCode;

  User({
    required this.fullName,
    required this.email,
    required this.thumbnailUrl,
    required this.largePictureUrl,
    required this.city,
    required this.country,
    required this.countryCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> name = json['name'];
    return User(
      fullName: '${name['title']} ${name['first']} ${name['last']}',
      email: json['email'],
      thumbnailUrl: json['picture']['thumbnail'],
      largePictureUrl: json['picture']['large'],
      city: json['location']['city'],
      country: json['location']['country'],
      countryCode: json['nat'] ?? '',
    );
  }

  String get location => '$city, $country';
  
  String get flagEmoji {
    // Convert country code to flag emoji
    if (countryCode.length != 2) return '';
    final codePoints = countryCode
        .toUpperCase()
        .split('')
        .map((char) => 127397 + char.codeUnitAt(0))
        .toList();
    return String.fromCharCodes(codePoints);
  }
}
