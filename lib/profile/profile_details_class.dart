class ProfileResponse {
  String status;
  ProfileData data;

  ProfileResponse({required this.status, required this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'],
      data: ProfileData.fromJson(json['data']['profile']),
    );
  }
}

class ProfileData {
  String id;
  String username;
  String phoneNumber;
  String image;
  List<dynamic> referredIds;
  Code? code; // Can be null, so mark it as nullable
  int token;
  List<TournamentProfile> tournamentsParticipated;
  int winnings;
  bool isVerified;
  DateTime createdAt;

  ProfileData({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.image,
    required this.referredIds,
    this.code, // Nullable code
    required this.token,
    required this.tournamentsParticipated,
    required this.winnings,
    required this.isVerified,
    required this.createdAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    print("profile_screen_print json file is $json");

    // Handle possible null for the tournament list
    var tournamentList = json['tournament_participated'] as List? ?? [];
    List<TournamentProfile> tournamentItems = tournamentList
        .map((t) => TournamentProfile.fromJson(t))
        .toList();

    return ProfileData(
      id: json['_id'],
      username: json['username'],
      phoneNumber: json['pno'],
      image: json['image'],
      referredIds: json['referredIds'] ?? [], // If null, set an empty list
      code: json['code'] != null ? Code.fromJson(json['code']) : null, // Check for null
      token: json['token'] ?? 0, // Default value if token is null
      tournamentsParticipated: tournamentItems,
      winnings: json['winnings'] ?? 0, // Default to 0 if winnings is null
      isVerified: json['isVerified'] ?? false, // Default to false if isVerified is null
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Code {
  String id;
  String username;

  Code({required this.id, required this.username});

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      id: json['_id'],
      username: json['username'],
    );
  }
}

class TournamentProfile {
  String id;
  String name;

  TournamentProfile({required this.id, required this.name});

  factory TournamentProfile.fromJson(Map<String, dynamic> json) {
    return TournamentProfile(
      id: json['_id'],
      name: json['name'],
    );
  }
}
