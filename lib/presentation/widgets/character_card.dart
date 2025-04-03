import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty_app/data/models/character.dart';
import 'package:rick_morty_app/domain/providers/character_provider.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  const CharacterCard({required this.character});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);
    final isFavorite = provider.favorites.any((fav) => fav.id == character.id);

    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(character.image),
        ),
        title: Text(character.name),
        subtitle: Text('${character.status} - ${character.species}'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.amber : null,
          ),
          onPressed: () => provider.toggleFavorite(character),
        ),
      ),
    );
  }
}