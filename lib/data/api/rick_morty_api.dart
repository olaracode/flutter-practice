import 'dart:convert';
import 'package:http/http.dart' as http;

export 'rick_morty_api.dart';

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

  Characters({
    required this.characters,
    required this.count,
    required this.next,
  });

  Characters.fromJson(Map<String, dynamic> json)
      : characters = (json['results'] as List)
            .map((item) => Character.fromMap(item as Map<String, dynamic>))
            .toList(),
        count = json['info']['count'],
        next = json['info']['next'];

  Map<String, dynamic> toJson() => {
        'results': characters,
        'info': {
          'count': count,
          'next': next,
        }
      };
}

Future<Characters> fetchCharacter() async {
  var response =
      await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));

  if (response.statusCode != 200) {
    throw Exception('Failed to load characters');
  }
  var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
  final apiResponse = Characters.fromJson(jsonResponse);
  return apiResponse;
}
