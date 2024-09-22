import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EmergencyDatabaseHelper {
  static final EmergencyDatabaseHelper instance = EmergencyDatabaseHelper._init();
  static Database? _database;

  EmergencyDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('emergency_requests.db');
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
    CREATE TABLE emergency_requests (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phonenumber TEXT NOT NULL,
      address TEXT NOT NULL,
      currentlocation TEXT NOT NULL,
      date TEXT NOT NULL,
      time TEXT NOT NULL,
      details TEXT NOT NULL
    )
  '''); // Add the closing parenthesis here
}


  Future<int> insertRequest(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('emergency_requests', row);
  }


  Future close() async {
    final db = await instance.database;
    db.close();
  }
  Future<List<Map<String, dynamic>>> getAllRequests() async {
    final db = await instance.database;
    return await db.query('emergency_requests');
  }
  Future<void> printAllRequests() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> requests = await db.query('emergency_requests');
    
    if (requests.isNotEmpty) {
      for (var request in requests) {
        print('Request ID: ${request['id']}');
        print('Name: ${request['name']}');
        print('Phone Number: ${request['phonenumber']}');
        print('Address: ${request['address']}');
        print('Current Location: ${request['currentlocation']}');
        print('Date: ${request['date']}');
        print('Time: ${request['time']}');
        print('Details: ${request['details']}');
        print('------------------------------');
      }
    } else {
      print('No requests found.');
    }
  }
}
