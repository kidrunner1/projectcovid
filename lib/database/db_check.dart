import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:tracker_covid_v1/model/check.dart';
import 'package:tracker_covid_v1/screen/check_covid/form_check.dart';

class CheckDB {
  String namedb;
  CheckDB({required this.namedb});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationSupportDirectory();
    String dbLocation = join(appDirectory.path, namedb);
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertData(CheckModel report) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");
    var keyID = store.add(db, {
      "date": report.date,
      "time": report.time,
      "weight": report.weight,
      "temp": report.temp,
      "type" : report.type
    });
    db.close();
    return keyID;
  }

  Future<List<CheckModel>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));
    List<CheckModel> checkList = [];

    for (var record in snapshot) {
      checkList.add(CheckModel(
          date: record["date"].toString(),
          time: record["time"].toString(),
          weight: record["weight"].toString(),
          temp: record["temp"].toString(), 
          type: record["type"].toString(), 
          

      ));
    }
    return checkList;
  }

  Future<void> deleteData(int id) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");

    try {
      await store.record(id).delete(db);
    } catch (e) {
      // Handle the error, e.g., log it.
    } finally {
      db.close();
    }
  }
}
