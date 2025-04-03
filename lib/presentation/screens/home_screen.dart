import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty_app/domain/providers/character_provider.dart';
import 'package:rick_morty_app/presentation/widgets/character_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CharacterProvider>(context, listen: false);
    provider.refresh();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = Provider.of<CharacterProvider>(context, listen: false);
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      provider.fetchCharacters();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CharacterProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Characters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.refresh(),
          ),
        ],
      ),
      body: _buildBody(provider),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBody(CharacterProvider provider) {
    if (provider.characters.isEmpty && provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (provider.characters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Нет данных'),
            ElevatedButton(
              onPressed: () => provider.refresh(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: provider.hasMore 
            ? provider.characters.length + 1 
            : provider.characters.length,
        itemBuilder: (context, index) {
          if (index >= provider.characters.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return CharacterCard(character: provider.characters[index]);
        },
      ),
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Избранное'),
      ],
      currentIndex: 0,
      onTap: (index) {
        if (index == 1) {
          Navigator.pushNamed(context, '/favorites');
        }
      },
    );
  }
}