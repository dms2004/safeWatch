import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('authority_requests.db');
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
      CREATE TABLE authority_requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        authority TEXT NOT NULL,
        incident_date TEXT NOT NULL,
        details TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertRequest(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('authority_requests', row);
  }


  Future close() async {
    final db = await instance.database;
    db.close();
  }
  Future<List<Map<String, dynamic>>> getAllRequests() async {
    final db = await instance.database;
    return await db.query('authority_requests');
  }
  Future<void> printAllRequests() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> requests = await db.query('authority_requests');
    
    if (requests.isNotEmpty) {
      for (var request in requests) {
        print('Request ID: ${request['id']}');
        print('Authority: ${request['authority']}');
        print('Date of Incident: ${request['incident_date']}');
        print('Details: ${request['details']}');
        print('------------------------------');
      }
    } else {
      print('No requests found.');
    }
  }
}
