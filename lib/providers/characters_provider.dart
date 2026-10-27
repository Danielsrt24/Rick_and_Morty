import 'package:flutter/foundation.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../database/database_helper.dart';

class CharactersProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Character> _characters = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';

  List<Character> _favoriteCharacters = [];
  Set<int> _favoriteIds = {};
  int? _currentUserId;

  List<Character> get characters => _characters;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Character> get favoriteCharacters => _favoriteCharacters;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get hasNextPage => _currentPage < _totalPages;
  bool get hasPrevPage => _currentPage > 1;

  Future<void> setCurrentUser(int userId) async {
    _currentUserId = userId;
    await _loadFavoriteIds();
    await _loadFavoriteCharacters();
  }

  Future<void> _loadFavoriteIds() async {
    if (_currentUserId == null) return;
    final favorites = await _dbHelper.getFavoritesByUserId(_currentUserId!);
    _favoriteIds = favorites.map((f) => f['character_id'] as int).toSet();
    notifyListeners();
  }

  Future<void> _loadFavoriteCharacters() async {
    if (_currentUserId == null || _favoriteIds.isEmpty) {
      _favoriteCharacters = [];
      notifyListeners();
      return;
    }
    try {
      _favoriteCharacters = await _apiService.getCharactersByIds(_favoriteIds.toList());
      notifyListeners();
    } catch (e) {
      print('Error cargando favoritos: $e');
    }
  }

  bool isFavorite(int characterId) {
    return _favoriteIds.contains(characterId);
  }

  Future<void> toggleFavorite(Character character) async {
    if (_currentUserId == null) return;

    if (_favoriteIds.contains(character.id)) {
      await _dbHelper.deleteFavorite(character.id, _currentUserId!);
      _favoriteIds.remove(character.id);
      _favoriteCharacters.removeWhere((c) => c.id == character.id);
    } else {
      await _dbHelper.insertFavorite({
        'user_id': _currentUserId,
        'character_id': character.id,
        'character_name': character.name,
        'character_status': character.status,
        'character_species': character.species,
        'character_image': character.image,
      });
      _favoriteIds.add(character.id);
      _favoriteCharacters.add(character);
    }
    notifyListeners();
  }

  Future<void> loadCharacters() async {
    _currentPage = 1;
    _searchQuery = '';
    await _fetchCharacters();
  }

  Future<void> searchCharacters(String query) async {
    _searchQuery = query;
    _currentPage = 1;
    await _fetchCharacters();
  }

  Future<void> nextPage() async {
    if (hasNextPage) {
      _currentPage++;
      await _fetchCharacters();
    }
  }

  Future<void> previousPage() async {
    if (hasPrevPage) {
      _currentPage--;
      await _fetchCharacters();
    }
  }

  Future<void> _fetchCharacters() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.getCharacters(
        page: _currentPage,
        nameFilter: _searchQuery.isEmpty ? null : _searchQuery,
      );
      _characters = response.results;
      _totalPages = response.info.pages;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _characters = [];
      notifyListeners();
    }
  }

  Future<void> retry() async {
    await _fetchCharacters();
  }
}