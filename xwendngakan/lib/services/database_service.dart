import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/institution.dart';

/// Local SQLite database for offline caching
class DatabaseService {
  static Database? _database;
  static const String _dbName = 'xwendngakan.db';
  static const int _dbVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Institutions table
    await db.execute('''
      CREATE TABLE institutions (
        id INTEGER PRIMARY KEY,
        data TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Favorites table (for offline favorite tracking)
    await db.execute('''
      CREATE TABLE favorites (
        institution_id INTEGER PRIMARY KEY,
        created_at INTEGER NOT NULL
      )
    ''');

    // Cache metadata
    await db.execute('''
      CREATE TABLE cache_meta (
        key TEXT PRIMARY KEY,
        value TEXT,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Create index for faster lookups
    await db.execute('CREATE INDEX idx_institutions_updated ON institutions(updated_at)');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here
    if (oldVersion < 2) {
      // Future migrations
    }
  }

  // ── Institutions ──

  /// Cache a list of institutions
  static Future<void> cacheInstitutions(List<Institution> institutions) async {
    final db = await database;
    final batch = db.batch();

    // Clear existing cache
    batch.delete('institutions');

    final now = DateTime.now().millisecondsSinceEpoch;

    for (final inst in institutions) {
      batch.insert(
        'institutions',
        {
          'id': inst.id,
          'data': jsonEncode(inst.toJson()),
          'updated_at': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);

    // Update cache timestamp
    await _setCacheMeta('institutions_cached_at', now.toString());
  }

  /// Get all cached institutions
  static Future<List<Institution>> getCachedInstitutions() async {
    final db = await database;
    final results = await db.query('institutions', orderBy: 'id DESC');

    return results.map((row) {
      final data = jsonDecode(row['data'] as String);
      return Institution.fromJson(data);
    }).toList();
  }

  /// Get a single cached institution
  static Future<Institution?> getCachedInstitution(int id) async {
    final db = await database;
    final results = await db.query(
      'institutions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) return null;

    final data = jsonDecode(results.first['data'] as String);
    return Institution.fromJson(data);
  }

  /// Check if cache is valid (less than 1 hour old)
  static Future<bool> isCacheValid({Duration maxAge = const Duration(hours: 1)}) async {
    final cachedAt = await _getCacheMeta('institutions_cached_at');
    if (cachedAt == null) return false;

    final timestamp = int.tryParse(cachedAt);
    if (timestamp == null) return false;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateTime.now().difference(cachedTime) < maxAge;
  }

  /// Clear all cached institutions
  static Future<void> clearInstitutionsCache() async {
    final db = await database;
    await db.delete('institutions');
    await _deleteCacheMeta('institutions_cached_at');
  }

  // ── Favorites (Offline) ──

  /// Save a favorite locally
  static Future<void> saveFavorite(int institutionId) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'institution_id': institutionId,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Remove a favorite locally
  static Future<void> removeFavorite(int institutionId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'institution_id = ?',
      whereArgs: [institutionId],
    );
  }

  /// Get all favorite IDs
  static Future<List<int>> getFavoriteIds() async {
    final db = await database;
    final results = await db.query('favorites');
    return results.map((row) => row['institution_id'] as int).toList();
  }

  /// Check if an institution is favorited
  static Future<bool> isFavorite(int institutionId) async {
    final db = await database;
    final results = await db.query(
      'favorites',
      where: 'institution_id = ?',
      whereArgs: [institutionId],
      limit: 1,
    );
    return results.isNotEmpty;
  }

  /// Sync local favorites with server
  static Future<void> syncFavorites(List<int> serverFavorites) async {
    final db = await database;
    final batch = db.batch();

    // Clear local favorites
    batch.delete('favorites');

    // Insert server favorites
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final id in serverFavorites) {
      batch.insert(
        'favorites',
        {'institution_id': id, 'created_at': now},
      );
    }

    await batch.commit(noResult: true);
  }

  // ── Cache Metadata ──

  static Future<void> _setCacheMeta(String key, String value) async {
    final db = await database;
    await db.insert(
      'cache_meta',
      {
        'key': key,
        'value': value,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String?> _getCacheMeta(String key) async {
    final db = await database;
    final results = await db.query(
      'cache_meta',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (results.isEmpty) return null;
    return results.first['value'] as String?;
  }

  static Future<void> _deleteCacheMeta(String key) async {
    final db = await database;
    await db.delete(
      'cache_meta',
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  // ── Utilities ──

  /// Clear all cached data
  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('institutions');
    await db.delete('favorites');
    await db.delete('cache_meta');
  }

  /// Get database size in bytes
  static Future<int> getDatabaseSize() async {
    try {
      final path = join(await getDatabasesPath(), _dbName);
      final file = File(path);
      if (await file.exists()) {
        return await file.length();
      }
    } catch (e) {
      // Ignore errors
    }
    return 0;
  }

  /// Close database connection
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
