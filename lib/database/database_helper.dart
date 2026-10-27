import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'rick_morty.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        character_id INTEGER NOT NULL,
        character_name TEXT NOT NULL,
        character_status TEXT,
        character_species TEXT,
        character_image TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    String password = user['password'];
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    user['password'] = digest.toString();
    
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> validateUser(String email, String password) async {
    Database db = await database;
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, digest.toString()],
    );
    
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<int> insertFavorite(Map<String, dynamic> favorite) async {
    Database db = await database;
    return await db.insert('favorites', favorite);
  }

  Future<List<Map<String, dynamic>>> getFavoritesByUserId(int userId) async {
    Database db = await database;
    return await db.query(
      'favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> deleteFavorite(int characterId, int userId) async {
    Database db = await database;
    return await db.delete(
      'favorites',
      where: 'character_id = ? AND user_id = ?',
      whereArgs: [characterId, userId],
    );
  }

  Future<bool> isFavorite(int characterId, int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'character_id = ? AND user_id = ?',
      whereArgs: [characterId, userId],
    );
    return maps.isNotEmpty;
  }
}