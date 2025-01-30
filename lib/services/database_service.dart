import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/dog_model.dart';
import '../models/journey_model.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'tot_app.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Dogs table
    await db.execute('''
      CREATE TABLE dogs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        breed_group TEXT NOT NULL,
        size TEXT NOT NULL,
        lifespan TEXT NOT NULL,
        origin TEXT NOT NULL,
        temperament TEXT NOT NULL,
        colors TEXT NOT NULL,
        description TEXT NOT NULL,
        image TEXT NOT NULL
      )
    ''');

    // Journeys table
    await db.execute('''
      CREATE TABLE journeys(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        source_lat REAL NOT NULL,
        source_lng REAL NOT NULL,
        dest_lat REAL NOT NULL,
        dest_lng REAL NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        route_points TEXT NOT NULL,
        distance REAL NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Backup existing data if needed
      List<Map<String, dynamic>> oldDogs = [];
      try {
        oldDogs = await db.query('dogs');
      } catch (e) {
        print('No existing dogs table found: $e');
      }

      // Drop and recreate dogs table
      await db.execute('DROP TABLE IF EXISTS dogs');
      await db.execute('''
        CREATE TABLE dogs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          breed_group TEXT NOT NULL,
          size TEXT NOT NULL,
          lifespan TEXT NOT NULL,
          origin TEXT NOT NULL,
          temperament TEXT NOT NULL,
          colors TEXT NOT NULL,
          description TEXT NOT NULL,
          image TEXT NOT NULL
        )
      ''');

      // Restore data if needed
      for (var dog in oldDogs) {
        try {
          await db.insert('dogs', dog);
        } catch (e) {
          print('Error restoring dog data: $e');
        }
      }
    }
  }

  // Dog operations
  Future<int> saveDog(Dog dog) async {
    try {
      final db = await database;
      return await db.insert(
        'dogs',
        dog.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to save dog: $e');
    }
  }

  Future<List<Dog>> getSavedDogs() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('dogs');
      return List.generate(maps.length, (i) => Dog.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Failed to get saved dogs: $e');
    }
  }

  Future<Dog?> getDogById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'dogs',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        return null;
      }
      return Dog.fromMap(maps.first);
    } catch (e) {
      throw Exception('Failed to get dog by id: $e');
    }
  }

  Future<int> deleteDog(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'dogs',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete dog: $e');
    }
  }

  Future<void> deleteAllDogs() async {
    try {
      final db = await database;
      await db.delete('dogs');
    } catch (e) {
      throw Exception('Failed to delete all dogs: $e');
    }
  }

  // Journey operations
  Future<int> saveJourney(Journey journey) async {
    try {
      final db = await database;
      return await db.insert(
        'journeys',
        journey.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to save journey: $e');
    }
  }

  Future<List<Journey>> getSavedJourneys() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'journeys',
        orderBy: 'start_time DESC',
      );
      return List.generate(maps.length, (i) => Journey.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Failed to get saved journeys: $e');
    }
  }

  Future<Journey?> getJourneyById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'journeys',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        return null;
      }
      return Journey.fromMap(maps.first);
    } catch (e) {
      throw Exception('Failed to get journey by id: $e');
    }
  }

  Future<int> deleteJourney(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'journeys',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete journey: $e');
    }
  }

  Future<void> deleteAllJourneys() async {
    try {
      final db = await database;
      await db.delete('journeys');
    } catch (e) {
      throw Exception('Failed to delete all journeys: $e');
    }
  }

  // Database maintenance operations
  Future<void> deleteDatabase() async {
    try {
      final path = join(await getDatabasesPath(), 'tot_app.db');
      await databaseFactory.deleteDatabase(path);
      _database = null;
    } catch (e) {
      throw Exception('Failed to delete database: $e');
    }
  }

  Future<void> close() async {
    try {
      if (_database != null) {
        await _database!.close();
        _database = null;
      }
    } catch (e) {
      throw Exception('Failed to close database: $e');
    }
  }
}
