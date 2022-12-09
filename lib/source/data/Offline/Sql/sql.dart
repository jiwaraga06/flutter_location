import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'dart:async';

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SQLHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'tester.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        await createTableTask(database);
        await createTableSubTask(database);
      },
    );
  }

  static Future<void> createTableHistory(sql.Database database) async {
    await database.execute('''
            CREATE TABLE if not exists history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            barcode TEXT,
            nama TEXT,
            lat DOUBLE,
            lng DOUBLE,
            warna TEXT,
            gender TEXT,
            waktu TEXT
            )
            ''');
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
            CREATE TABLE if not exists lokasi (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama_lokasi TEXT,
            lati DOUBLE,
            longi DOUBLE,
            keterangan TEXT,
            created_at TEXT,
            updated_at TEXT,
            user_creator TEXT,
            aktif TEXT,
            isOffline INTEGER
            )
            ''');
  }

  static Future<void> createTableTask(sql.Database database) async {
    await database.execute('''
            CREATE TABLE if not exists tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_lokasi INTEGER,
            task TEXT,
            user_creator TEXT,
            created_at TEXT,
            updated_at TEXT,
            isOffline INTEGER
            )
            ''');
  }

  static Future<void> createTableSubTask(sql.Database database) async {
    await database.execute('''
            CREATE TABLE if not exists sub_task (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_task INTEGER,
            sub_task TEXT,
            keterangan TEXT,
            is_aktif INTEGER,
            created_at TEXT,
            updated_at TEXT,
            isOffline INTEGER
            )
            ''');
  }

  // TABEL HISTORY LOKASI SECURITY
  static Future insertHistory(barcode, nama, latitude, longitude, warna, gender, waktu) async {
    final db = await SQLHelper.db();
    var data = {"barcode": barcode, "nama": nama, "lat": latitude, "lng": longitude, "warna": warna, "gender": gender, 'waktu': waktu};
    final result = await db.insert('history', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return result;
  }

  static Future getHistory() async {
    final db = await SQLHelper.db();
    final result = await db.query('history');
    print('history');
    // print(result);
    print(result.length);
    return result;
  }

  static Future deleteHistory() async {
    final db = await SQLHelper.db();
    final result = await db.delete('history');
    print('delete history');
    print(result);
    return result;
  }

  // SELECT 3 TABEL/ JOIN TABEL
  static Future getLokasiByID(id) async {
    final db = await SQLHelper.db();
    var body = [];
    var listTask = [];
    var listSubTask = [];
    // var lokasi = await db.query('lokasi', where: 'id=?', whereArgs: [id]);
    var tasks = await db.query('tasks', where: 'id_lokasi=?', whereArgs: [id]);
    var sub_task = await db.rawQuery('SELECT * FROM sub_task');
    print('SELECT TASK BY ID LOKASI');
    tasks.map((e) {
      var cariSubtask = sub_task.where((el) => el['id_task'] == e['id']).toList();
      var a = {
        'id': e['id'],
        'id_lokasi': e['id_lokasi'],
        'task': e['task'],
        'created_at': e['created_at'],
        'updated_at': e['updated_at'],
        'sub_task': cariSubtask.toList()
      };
      body.add(a);
    }).toList();
    // var cariSubtask = sub_task.where((element) => element['id_task'] == 28).toList();
    // print(tasks.length);
    print(body);
    return body;
  }

  static Future getLokasiTaskSubtask() async {
    final db = await SQLHelper.db();
    var body = [];
    var listTask = [];
    var listSubTask = [];
    var lokasi = await db.rawQuery('SELECT * FROM lokasi');
    var tasks = await db.rawQuery('SELECT * FROM tasks');
    var sub_task = await db.rawQuery('SELECT * FROM sub_task');
    print('JOIN TABEL');
    lokasi.map((e) {
      var caritask = tasks.where((element) => element['id_lokasi'] == e['id']).toList();
      caritask.map((i) {
        var a = {
          'id': i['id'],
          'id_lokasi': i['id_lokasi'],
          'task': i['task'],
          'user_creator': i['user_creator'],
          'created_at': i['created_at'],
          'updated_at': i['updated_at'],
        };
        return a;
      }).toList();
      // print(caritask.length);
      var a = {
        'id': e['id'],
        'nama_lokasi': e['nama_lokasi'],
        'lati': e['lati'],
        'longi': e['longi'],
        'keterangan': e['keterangan'],
        'created_at': e['created_at'],
        'updated_at': e['updated_at'],
        'user_creator': e['user_creator'],
        'aktif': e['aktif'],
        'tasks': caritask.map((i) {
          var cariSubtask = sub_task.where((el) => el['id_task'] == i['id']).toList();
          var a = {
            'id': i['id'],
            'id_lokasi': i['id_lokasi'],
            'task': i['task'],
            'user_creator': i['user_creator'],
            'created_at': i['created_at'],
            'updated_at': i['updated_at'],
            'sub_task': cariSubtask.map((ii) {
              var c = {
                'id': ii['id'],
                'id_task': ii['id_task'],
                'sub_task': ii['sub_task'],
                'keterangan': ii['keterangan'],
                'is_aktif': ii['is_aktif'],
                'created-at': ii['created-at'],
                'updated_at': ii['updated_at'],
              };
              return c;
            }).toList()
          };
          return a;
        }).toList()
      };
      body.add(a);
    }).toList();
    // var cariSubtask = sub_task.where((element) => element['id_task'] == 28).toList();
    // print(tasks.length);
    print(body);
    return body;
  }

  static Future getLokasiTaskSubtaskByLokal() async {
    final db = await SQLHelper.db();
    var body = [];
    var listTask = [];
    var listSubTask = [];
    var lokasi = await db.rawQuery('SELECT * FROM lokasi where isOffline =1');
    var tasks = await db.rawQuery('SELECT * FROM tasks where isOffline =1');
    var sub_task = await db.rawQuery('SELECT * FROM sub_task where isOffline =1');
    print('JOIN TABEL');
    lokasi.map((e) {
      var caritask = tasks.where((element) => element['id_lokasi'] == e['id']).toList();
      caritask.map((i) {
        var a = {
          'id': i['id'],
          'id_lokasi': i['id_lokasi'],
          'task': i['task'],
          'user_creator': i['user_creator'],
          'created_at': i['created_at'],
          'updated_at': i['updated_at'],
        };
        return a;
      }).toList();
      // print(caritask.length);
      var a = {
        'id': e['id'],
        'nama_lokasi': e['nama_lokasi'],
        'lati': e['lati'],
        'longi': e['longi'],
        'keterangan': e['keterangan'],
        'created_at': e['created_at'],
        'updated_at': e['updated_at'],
        'user_creator': e['user_creator'],
        'aktif': e['aktif'],
        'tasks': caritask.map((i) {
          var cariSubtask = sub_task.where((el) => el['id_task'] == i['id']).toList();
          var a = {
            'id': i['id'],
            'id_lokasi': i['id_lokasi'],
            'task': i['task'],
            'user_creator': i['user_creator'],
            'created_at': i['created_at'],
            'updated_at': i['updated_at'],
            'sub_task': cariSubtask.map((ii) {
              var c = {
                'id': ii['id'],
                'id_task': ii['id_task'],
                'sub_task': ii['sub_task'],
                'keterangan': ii['keterangan'],
                'is_aktif': ii['is_aktif'],
                'created-at': ii['created-at'],
                'updated_at': ii['updated_at'],
              };
              return c;
            }).toList()
          };
          return a;
        }).toList()
      };
      body.add(a);
    }).toList();
    // var cariSubtask = sub_task.where((element) => element['id_task'] == 28).toList();
    // print(tasks.length);
    print(body);
    return body;
  }

// TABEL LOKASI
  static Future getItemList() async {
    final db = await SQLHelper.db();
    var mapList = await db.query('lokasi');
    print(mapList);
    return mapList;
  }

  static Future insertLokasi(id, nama_lokasi, lati, longi, keterangan, created_at, updated_at, user_creator, aktif) async {
    final db = await SQLHelper.db();
    var cari = await db.query('lokasi', where: '''
          id = ? AND
          nama_lokasi = ? AND
          lati = ? AND
          longi = ? AND
          keterangan = ? AND
          created_at = ? AND
          updated_at = ? AND
          user_creator = ? AND
          aktif = ?
          ''');
    // print('cari');
    // print(cari);
    if (cari.length == 0) {
      final data = {
        'id': id,
        'nama_lokasi': nama_lokasi,
        'lati': lati,
        'longi': longi,
        'keterangan': keterangan,
        'created_at': created_at,
        'updated_at': updated_at,
        'user_creator': user_creator,
        'aktif': aktif,
        'isOffline': 0,
      };
      final result = await db.insert('lokasi', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      // print('result lokasi');
      // print(result);
      return result;
    }
  }

  static Future insertLokasiForm(nama_lokasi, lati, longi, keterangan, created_at, updated_at, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    final db = await SQLHelper.db();
    var cari = await db.query('lokasi', where: 'nama_lokasi = ? ', whereArgs: [nama_lokasi], limit: 1);
    // print('cari');
    // print(cari);
    if (cari.length != 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data ini sudah ada')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
    if (cari.length == 0) {
      final data = {
        'nama_lokasi': nama_lokasi,
        'lati': lati,
        'longi': longi,
        'keterangan': keterangan,
        'created_at': created_at,
        'updated_at': updated_at,
        'user_creator': barcode,
        'aktif': 'Y',
        'isOffline': 1,
      };
      final result = await db.insert('lokasi', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      print('result lokasi');
      print(result);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data berhasil di tambahkan')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
      return result;
    }
  }

  static Future updateLokasiForm(id, nama_lokasi, lati, longi, keterangan, updated_at, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    final db = await SQLHelper.db();
    var cari = await db.query('lokasi', where: 'nama_lokasi = ? ', whereArgs: [nama_lokasi], limit: 1);
    // print('cari');
    // print(cari);
    if (cari.length != 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data ini sudah ada')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
    if (cari.length == 0) {
      final data = {
        'nama_lokasi': nama_lokasi,
        'lati': lati,
        'longi': longi,
        'keterangan': keterangan,
        'updated_at': updated_at,
        'user_creator': barcode,
        'aktif': 'Y',
        'isOffline': 1,
      };
      final result = await db.update('lokasi', data, where: 'id =?', whereArgs: [id]);
      print('result lokasi');
      print(result);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data berhasil di ubah')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
      return result;
    }
  }

  static Future deleteLokasi(id) async {
    final db = await SQLHelper.db();
    var mapList = await db.delete('lokasi', where: 'id=?', whereArgs: [id]);
    print('delete lokasi');
    print(mapList);
    return mapList;
  }

  // TABEL TASKS
  static Future getTasks() async {
    final db = await SQLHelper.db();
    var mapList = await db.query('tasks');
    print('tasks');
    print(mapList);
    return mapList;
  }

  static Future insertTask(id, id_lokasi, task, created_at, updated_at, user_creator) async {
    final db = await SQLHelper.db();
    var cari = await db.query('tasks', where: '''
          id = ? AND
          id_lokasi = ? AND
          task = ? AND
          user_creator = ? AND
          created_at = ? AND
          updated_at = ? 
          ''');
    // print('task');
    // print(cari);
    if (cari.length == 0) {
      final data = {
        'id': id,
        'id_lokasi': id_lokasi,
        'task': task,
        'user_creator': user_creator,
        'created_at': created_at,
        'updated_at': updated_at,
        'isOffline': 0,
      };
      final result = await db.insert('tasks', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      // print('result tasks');
      // print(result);
      return result;
    }
  }

  static Future insertTaskForm(id_lokasi, task, created_at, updated_at, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    final db = await SQLHelper.db();
    var cari = await db.query('tasks', where: 'task = ?', whereArgs: [task]);
    // print('task');
    // print(cari);
    if (cari.length != 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data ini sudah ada')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
    if (cari.length == 0) {
      final data = {
        'id_lokasi': id_lokasi,
        'task': task,
        'user_creator': barcode,
        'created_at': created_at,
        'updated_at': updated_at,
        'isOffline': 1,
      };
      final result = await db.insert('tasks', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      print('result tasks');
      print(result);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data ini berhasil di tambahkan')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
      return result;
    }
  }

  static Future updateTaskForm(id, id_lokasi, task, updated_at, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var barcode = pref.getString('barcode');
    final db = await SQLHelper.db();
    var cari = await db.query('tasks', where: 'task = ?', whereArgs: [task]);
    // print('task');
    // print(cari);
    if (cari.length != 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data ini sudah ada')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
    if (cari.length == 0) {
      final data = {
        'id': id,
        'id_lokasi': id_lokasi,
        'task': task,
        'user_creator': barcode,
        'updated_at': updated_at,
        'isOffline': 1,
      };
      final result = await db.update('tasks', data, where: 'id=?', whereArgs: [id]);
      print('result tasks');
      print(result);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data ini berhasil di Update')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
      return result;
    }
  }

  static Future deleteTask(id) async {
    final db = await SQLHelper.db();
    var mapList = await db.delete('tasks', where: 'id=?', whereArgs: [id]);
    print('delete lokasi');
    print(mapList);
    return mapList;
  }

// TABEL SUB TASK

  static Future getSubTasks() async {
    final db = await SQLHelper.db();
    var mapList = await db.query('sub_task');
    print('sub_task');
    print(mapList);
    return mapList;
  }

  static Future insertSubTask(id, id_task, sub_task, keterangan, is_aktif, created_at, updated_at) async {
    final db = await SQLHelper.db();
    var cari = await db.query('sub_task', where: '''
          id = ? AND
          id_task = ? AND
          sub_task = ? AND
          keterangan = ? AND
          is_aktif = ? AND
          created_at = ? AND
          updated_at = ? 
          ''');
    // print('sub_task');
    // print(cari);
    if (cari.length == 0) {
      final data = {
        'id': id,
        'id_task': id_task,
        'sub_task': sub_task,
        'keterangan': keterangan,
        'is_aktif': is_aktif,
        'created_at': created_at,
        'updated_at': updated_at,
        'isOffline': 0,
      };
      final result = await db.insert('sub_task', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      // print('result sub tasks');
      // print(result);
      return result;
    }
  }

  static Future insertSubTaskForm(id_task, sub_task, keterangan, is_aktif, created_at, updated_at, context) async {
    final db = await SQLHelper.db();
    var cari = await db.query('sub_task', where: 'sub_task = ? ', whereArgs: [sub_task]);
    // print('sub_task');
    // print(cari);
    if (cari.length != 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data ini sudah ada')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
    if (cari.length == 0) {
      final data = {
        'id_task': id_task,
        'sub_task': sub_task,
        'keterangan': keterangan,
        'is_aktif': is_aktif,
        'created_at': created_at,
        'updated_at': updated_at,
        'isOffline': 1,
      };
      final result = await db.insert('sub_task', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      print('result sub tasks');
      print(result);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data ini berhasil di Tambahkan')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
      return result;
    }
  }

  static Future updateSubTaskForm(id, id_task, sub_task, keterangan, is_aktif, updated_at, context) async {
    final db = await SQLHelper.db();
    var cari = await db.query('sub_task', where: 'sub_task = ? ', whereArgs: [sub_task]);
    // print('sub_task');
    // print(cari);
    if (cari.length != 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data ini sudah ada')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
    if (cari.length == 0) {
      final data = {
        'id': id,
        'id_task': id_task,
        'sub_task': sub_task,
        'keterangan': keterangan,
        'is_aktif': is_aktif,
        'updated_at': updated_at,
        'isOffline': 1,
      };
      final result = await db.update('sub_task', data, where: 'id=?', whereArgs: [id]);
      print('result sub tasks');
      print(result);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text('Data ini berhasil di Update')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
      return result;
    }
  }

  static Future deleteSubTask(id) async {
    final db = await SQLHelper.db();
    var mapList = await db.delete('sub_task', where: 'id=?', whereArgs: [id]);
    print('delete lokasi');
    print(mapList);
    return mapList;
  }
}
