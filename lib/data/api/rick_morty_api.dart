import 'dart:convert';
import 'package:http/http.dart' as http;

export 'rick_morty_api.dart';

int getPage(String url) {
  final uri = Uri.parse(url);
  final page = uri.queryParameters['page'];
  return int.parse(page ?? '1');
}

class Character {
  final String name;
  final String status;
  final String species;
  final String imgUrl;

  Character({
    required this.name,
    required this.status,
    required this.species,
    required this.imgUrl,
  });

  Character.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        status = map['status'],
        species = map['species'],
        imgUrl = map['image'];
}

class Characters {
  final List<dynamic> characters;
  final int count;
  final String next;
  final String previous;
  final int currentPage;

  Characters(
      {required this.characters,
      required this.count,
      required this.next,
      required this.previous,
      required this.currentPage});

  Characters.fromJson(Map<String, dynamic> json)
      : characters = (json['results'] as List)
            .map((item) => Character.fromMap(item as Map<String, dynamic>))
            .toList(),
        count = json['info']['count'],
        next = json['info']['next'],
        previous = json['info']['prev'] ?? '',
        currentPage = getPage(json['info']['next'] ?? '');

  Map<String, dynamic> toJson() => {
        'results': characters,
        'info': {
          'count': count,
          'next': next,
          'previous': previous,
          'currentPage': currentPage,
        }
      };
}

Future<Characters> fetchCharacter({String? url}) async {
  final endpoint = url ?? 'https://rickandmortyapi.com/api/character';
  var response = await http.get(Uri.parse(endpoint));

  if (response.statusCode != 200) {
    throw Exception('Failed to load characters');
  }
  var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

  final apiResponse = Characters.fromJson(jsonResponse);
  return apiResponse;
}
