class CharacterResponse {
  final Info info;
  final List<Character> results;

  CharacterResponse({required this.info, required this.results});

  factory CharacterResponse.fromJson(Map<String, dynamic> json) {
    return CharacterResponse(
      info: Info.fromJson(json['info']),
      results: (json['results'] as List)
          .map((i) => Character.fromJson(i))
          .toList(),
    );
  }
}

class Info {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  Info({required this.count, required this.pages, this.next, this.prev});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json['count'] ?? 0,
      pages: json['pages'] ?? 0,
      next: json['next'],
      prev: json['prev'],
    );
  }
}

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final LocationInfo origin;
  final LocationInfo location;
  final String image;
  final List<String> episode;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      status: json['status'] ?? 'Unknown',
      species: json['species'] ?? 'Unknown',
      gender: json['gender'] ?? 'Unknown',
      origin: json['origin'] != null
          ? LocationInfo.fromJson(json['origin'])
          : LocationInfo(name: 'Unknown', url: ''),
      location: json['location'] != null
          ? LocationInfo.fromJson(json['location'])
          : LocationInfo(name: 'Unknown', url: ''),
      image: json['image'] ?? '',
      episode: (json['episode'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class LocationInfo {
  final String name;
  final String url;

  LocationInfo({required this.name, required this.url});

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      name: json['name'] ?? 'Unknown',
      url: json['url'] ?? '',
    );
  }
}