import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/student_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // 🔹 Create a single static instance
  static final DatabaseHelper instance = DatabaseHelper._internal();

  // 🔹 Private named constructor
  DatabaseHelper._internal();
  static Database? _db;

  // Singleton getter
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  // Initialize database
  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), "mydb.db");
    debugPrint("📁 Database Path: $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT
          )
        ''');


        await db.execute('''
          CREATE TABLE students (
            r_no INTEGER PRIMARY KEY AUTOINCREMENT,
            student_name TEXT,
            student_email VARCHAR,
            student_contact INTEGER,
            password VARCHAR,
            branch TEXT,
            course TEXT,
            sub_category TEXT,
            type_of_course TEXT,
            duration TEXT,
            date TEXT,
            student_image TEXT
          )
        ''');
      },
      // onUpgrade: (db, oldVersion, newVersion) async {
      //   if (oldVersion < 2) {}
      // },
    );
  }

  // ─────────────────────────────
  // 🧑‍🎓 STUDENT DATABASE METHODS
  // ─────────────────────────────
  Future<int> registerStudent(
      String studentName,
      String studentEmail,
      int studentContact,
      String password,
      String branch,
      String course,
      String subCategory,
      String typeOfCourse,
      String duration,
      String date,
      String studentImage,
      ) async {
    final database = await db; // ✅ FIX

    try {
      return await database.insert(
        'students',
        {
          'student_name': studentName,
          'student_email': studentEmail,
          'student_contact': studentContact,
          'password': password,
          'branch': branch,
          'course': course,
          'sub_category': subCategory,
          'type_of_course':typeOfCourse,
          'duration': duration,
          'date': date,
          'student_image': studentImage,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint("❌ Error inserting student: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllStudent() async {
    final database = await db;
    return await database.query("students");
  }

  Future<List<Map<String, dynamic>>> getSingleStudent(int id) async {
    final database = await db;
    return await database.query(
      "students",
      where: "r_no = ?",
      whereArgs: [id],
    );
  }

  // ─────────────────────────────
  // 📝 NOTES DATABASE METHODS
  // ─────────────────────────────
  Future<int> insertNote(String title, String content) async {
    final database = await db;
    return await database.insert(
      "notes",
      {"title": title, "content": content},
    );
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final database = await db;
    return await database.query("notes");
  }

  Future<int> deleteNote(int id) async {
    final database = await db;
    return await database.delete(
      "notes",
      where: "id = ?",
      whereArgs: [id],
    );
  }
  Future<Student?> validateStudent(String regId, String password) async {
    final database = await db; // ✅ ensures database is initialized

    final res = await database.query(
      'students',
      where: 'r_no = ? AND password = ?',
      whereArgs: [regId, password],
    );

    if (res.isNotEmpty) {
      return Student.fromMap(res.first);
    }
    return null;
  }

  Future<Student?> getStudentByRegId(String regId) async {
    final database = await db;
    final res = await database.query(
      'students',
      where: 'r_no = ?',
      whereArgs: [regId],
    );

    if (res.isNotEmpty) {
      return Student.fromMap(res.first);
    }
    return null;
  }


}
