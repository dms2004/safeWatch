import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProfileDatabaseHelper {
  static final ProfileDatabaseHelper instance = ProfileDatabaseHelper._init();
  static Database? _database;

  ProfileDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('profile_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void printDatabasePath() async {
  final dbPath = await getDatabasesPath();
  print('Database path: $dbPath');
}

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profile_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phonenumber TEXT NOT NULL,
        address TEXT NOT NULL
      )
    ''');
  }

  // Insert profiledata details into the database
  Future<int> insertprofiledata(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('profile_data', row);
  }

  // Query user by email for login verification
  Future<List<Map<String, dynamic>>> queryProfileByEmail(String email) async {
    final db = await instance.database;
    return await db.query(
      'profile_data',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // Print all profiledata details to the terminal (optional debugging)
  Future<void> printAllprofile() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> profile = await db.query('profile_data');
    
    if (profile.isNotEmpty) {
      for (var profiledata in profile) {
        print('Profile ID: ${profiledata['id']}');
        print('Name: ${profiledata['name']}');
        print('Email: ${profiledata['email']}');
        print('Phone Number: ${profiledata['phonenumber']}');
        print('Address: ${profiledata['address']}');
        print('------------------------------');
      }
    } else {
      print('No profiledata records found.');
    }
  }
}
