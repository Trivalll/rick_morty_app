import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty_app/domain/providers/character_provider.dart';
import 'package:rick_morty_app/presentation/widgets/character_card.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () => provider.sortFavorites(true),
            tooltip: 'Сортировать по имени',
          ),
        ],
      ),
      body: provider.favorites.isEmpty
          ? Center(child: Text('Нет избранных персонажей'))
          : ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) => CharacterCard(
                character: provider.favorites[index],
              ),
            ),
    );
  }
}