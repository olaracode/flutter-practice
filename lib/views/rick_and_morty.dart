import 'package:flutter/material.dart';
import 'package:todolist/data/api/rick_morty_api.dart' as rick_morty_api;

export 'rick_and_morty.dart';

class RickAndMorty extends StatefulWidget {
  const RickAndMorty({Key? key}) : super(key: key);
  @override
  State<RickAndMorty> createState() => _RickAndMortyState();
}

class _RickAndMortyState extends State<RickAndMorty> {
  late Future<rick_morty_api.Characters> rickAndMortyResponse;

  @override
  void initState() {
    super.initState();
    rickAndMortyResponse = rick_morty_api.fetchCharacter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Rick and Morty'),
            FutureBuilder<rick_morty_api.Characters>(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: snapshot.data!.previous == ""
                                  ? null
                                  : () {
                                      setState(() {
                                        rickAndMortyResponse =
                                            rick_morty_api.fetchCharacter(
                                                url: snapshot.data!.previous);
                                      });
                                    },
                              child: const Text("Previous"),
                            ),
                            Text('Page: ${snapshot.data!.currentPage - 1}'),
                            ElevatedButton(
                              onPressed: snapshot.data!.next == ""
                                  ? null
                                  : () {
                                      setState(() {
                                        rickAndMortyResponse =
                                            rick_morty_api.fetchCharacter(
                                                url: snapshot.data!.next);
                                      });
                                    },
                              child: const Text("Next"),
                            ),
                          ],
                        ),
                        for (var character in snapshot.data!.characters)
                          CharacterCard(character: character)
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  const CharacterCard({Key? key, required this.character}) : super(key: key);
  final rick_morty_api.Character character;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Card(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Image.network(character.imgUrl),
              ),
              Text(character.name),
              Text(character.status),
              Text(character.species),
            ],
          ),
        ),
      ],
    );
  }
}
