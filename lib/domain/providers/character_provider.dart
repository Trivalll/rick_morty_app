import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rick_morty_app/data/models/character.dart';
import 'package:rick_morty_app/core/services/api_service.dart';

class CharacterProvider extends ChangeNotifier {
  late Box<Character> _favoritesBox;
  final List<Character> _characters = [];
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  // Публичные геттеры
  List<Character> get characters => _characters;
  List<Character> get favorites => _favoritesBox.values.toList();
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  CharacterProvider() {
    _initHive();
    fetchCharacters();
  }

  Future<void> _initHive() async {
    _favoritesBox = await Hive.openBox<Character>('favorites');
  }

  Future<void> fetchCharacters() async {
    if (_isLoading || !_hasMore) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final newCharacters = await ApiService().getCharacters(page: _page);
      
      if (newCharacters.isEmpty) {
        _hasMore = false;
      } else {
        _characters.addAll(newCharacters);
        _page++;
      }
    } catch (e) {
      debugPrint('Ошибка загрузки: $e');
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    _characters.clear();
    await fetchCharacters();
  }

  void toggleFavorite(Character character) {
    if (_favoritesBox.containsKey(character.id)) {
      _favoritesBox.delete(character.id);
    } else {
      _favoritesBox.put(character.id, character);
    }
    notifyListeners();
  }

  sortFavorites(bool bool) {}
}