import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PublicDatabaseHelper {
  static final PublicDatabaseHelper instance = PublicDatabaseHelper._init();
  static Database? _database;

  PublicDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('public_requests.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  void printDatabasePath() async {
    final dbPath = await getDatabasesPath();
    print('Database path: $dbPath');
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE public_requests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        contact TEXT NOT NULL, 
        details TEXT NOT NULL,
        time TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertRequest(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('public_requests', row);
  }

  Future<List<Map<String, dynamic>>> getAllRequests() async {
    final db = await instance.database;
    return await db.query('public_requests');
  }

  Future<void> printAllRequests() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> requests = await db.query('public_requests');
    
    if (requests.isNotEmpty) {
      for (var request in requests) {
        print('Request ID: ${request['id']}');
        print('Title: ${request['title']}');
        print('Contact: ${request['contact']}'); 
        print('Details: ${request['details']}');
        print('Time: ${request['time']}');
        print('Date: ${request['date']}');
        print('------------------------------');
      }
    } else {
      print('No requests found.');
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
