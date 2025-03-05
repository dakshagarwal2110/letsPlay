class Tournament {
  String id;
  String name;
  String description;
  List<String> rules;
  List<String> scoreSubmissionRules;
  int prizePool;
  DateTime date;
  int participants;
  int teams;
  String image;
  int rounds;
  String gameType;
  int playersPerTeam;
  int entryToken;
  bool completed;
  List<String> winners;
  List<Player> playersParticipating;
  int stages;
  Map<String, Stage> roadmap;
  List<String> playerGameIds;
  String iosLink;
  String androidLink;
  String webLink;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.rules,
    required this.scoreSubmissionRules,
    required this.prizePool,
    required this.date,
    required this.participants,
    required this.teams,
    required this.image,
    required this.rounds,
    required this.gameType,
    required this.playersPerTeam,
    required this.entryToken,
    required this.completed,
    required this.winners,
    required this.playersParticipating,
    required this.stages,
    required this.roadmap,
    required this.playerGameIds,
    this.iosLink = "",
    this.androidLink = "",
    this.webLink = "",
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      rules: List<String>.from(json['rules'] ?? []),
      scoreSubmissionRules: List<String>.from(json['score_submission_rules'] ?? []),
      prizePool: json['prizePool'] ?? 0,
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      participants: json['participants'] ?? 0,
      teams: json['teams'] ?? 0,
      image: json['image'] ?? "",
      rounds: json['rounds'] ?? 0,
      gameType: json['gameType'] ?? "",
      playersPerTeam: json['playersPerTeam'] ?? 0,
      entryToken: json['entry_token'] ?? 0,
      completed: json['completed'] ?? false,
      winners: List<String>.from(json['winners'] ?? []),
      playersParticipating: (json['players_participating'] as List<dynamic>?)
          ?.map((player) => Player.fromJson(player))
          .toList() ??
          [],
      stages: json['stages'] ?? 0,
      roadmap: (json['roadmap'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, Stage.fromJson(value))) ??
          {},
      playerGameIds: List<String>.from(json['player_game_id'] ?? []),
      iosLink: json['ios_link'] ?? "",
      androidLink: json['android_link'] ?? "",
      webLink: json['web_link'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.isNotEmpty ? id : "",
      'name': name.isNotEmpty ? name : "",
      'description': description.isNotEmpty ? description : "",
      'rules': rules.isNotEmpty ? rules : [],
      'score_submission_rules': scoreSubmissionRules.isNotEmpty ? scoreSubmissionRules : [],
      'prizePool': prizePool,
      'date': date.toIso8601String(),
      'participants': participants,
      'teams': teams,
      'image': image.isNotEmpty ? image : "",
      'rounds': rounds,
      'gameType': gameType.isNotEmpty ? gameType : "",
      'playersPerTeam': playersPerTeam,
      'entry_token': entryToken,
      'completed': completed,
      'winners': winners.isNotEmpty ? winners : [],
      'players_participating': playersParticipating.map((player) => player.toJson()).toList(),
      'stages': stages,
      'roadmap': roadmap.map((key, value) => MapEntry(key, value.toJson())),
      'player_game_id': playerGameIds.isNotEmpty ? playerGameIds : [],
      'ios_link': iosLink.isNotEmpty ? iosLink : "",
      'android_link': androidLink.isNotEmpty ? androidLink : "",
      'web_link': webLink.isNotEmpty ? webLink : "",
    };
  }
}
class Player {
  String id;
  String username;
  String image;

  Player({
    required this.id,
    required this.username,
    required this.image,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['_id'] ?? "",
      username: json['username'] ?? "",
      image: json['image'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.isNotEmpty ? id : "",
      'username': username.isNotEmpty ? username : "",
      'image': image.isNotEmpty ? image : "",
    };
  }
}

class Stage {
  DateTime timestamp;
  bool completed;

  Stage({
    required this.timestamp,
    required this.completed,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'completed': completed,
    };
  }
}

class Winners {
  final String username;
  final String tournament_name;
  final String image;
  final String date;
  final int amount;

  Winners({
    required this.username,
    required this.tournament_name,
    required this.image,
    required this.date,
    required this.amount,
  });
}
