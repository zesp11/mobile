class UserProfile {
  final String id;
  String name;
  final String email;
  String avatar;
  String bio;
  final int gamesPlayed;
  final int gamesFinished;
  final Map<String, dynamic> preferences;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.bio,
    required this.gamesPlayed,
    required this.gamesFinished,
    required this.preferences,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: "", // TODO: discuss if no avatar should be null or ""
      bio: json['bio'],
      gamesPlayed: json['gamesPlayed'] ?? 0, // Default to 0 if not provided
      gamesFinished: json['gamesFinished'] ?? 0, // Default to 0 if not provided
      preferences: json['preferences'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'bio': bio,
      'gamesPlayed': gamesPlayed,
      'gamesFinished': gamesFinished,
      'preferences': preferences,
    };
  }
}
