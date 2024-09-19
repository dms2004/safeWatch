import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SignupDatabaseHelper {
  static final SignupDatabaseHelper instance = SignupDatabaseHelper._init();
  static Database? _database;

  SignupDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('signup_data.db');
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
      CREATE TABLE signup_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  // Insert signup details into the database
  Future<int> insertSignup(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('signup_data', row);
  }

  // Query user by email for login verification
  Future<List<Map<String, dynamic>>> queryUserByEmail(String email) async {
    final db = await instance.database;
    return await db.query(
      'signup_data',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // Print all signup details to the terminal (optional debugging)
  Future<void> printAllSignups() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> signups = await db.query('signup_data');
    
    if (signups.isNotEmpty) {
      for (var signup in signups) {
        print('Signup ID: ${signup['id']}');
        print('Name: ${signup['name']}');
        print('Email: ${signup['email']}');
        print('Password: ${signup['password']}');
        print('------------------------------');
      }
    } else {
      print('No signup records found.');
    }
  }
}
