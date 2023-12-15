import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
export 'rickandmorty.dart';

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
      : characters = json['results'],
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

class RickAndMorty extends StatefulWidget {
  const RickAndMorty({Key? key}) : super(key: key);
  @override
  State<RickAndMorty> createState() => _RickAndMortyState();
}

class _RickAndMortyState extends State<RickAndMorty> {
  late Future<Characters> rickAndMortyResponse;
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

  @override
  void initState() {
    super.initState();
    rickAndMortyResponse = fetchCharacter();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
      ),
      body: Center(
          child: Column(
        children: [
          const Text('Rick and Morty'),
          FutureBuilder<Characters>(
            future: rickAndMortyResponse,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Expanded(
                  child: ListView(
                    children: [
                      for (var character in snapshot.data!.characters)
                        CharacterCard(
                          character: Character(
                            name: character['name'],
                            status: character['status'],
                            species: character['species'],
                            imgUrl: character['image'],
                          ),
                        )
                    ],
                  ),
                );
              }
            },
          ),
        ],
      )),
    );
  }
}

class CharacterCard extends StatelessWidget {
  const CharacterCard({Key? key, required this.character}) : super(key: key);
  final Character character;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(character.imgUrl),
          Text(character.name),
          Text(character.status),
          Text(character.species),
        ],
      ),
    );
  }
}
