import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:tracker_covid_v1/model/appoints.dart';

class AppointmentDB {
  String dbName;
  AppointmentDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationSupportDirectory();
    String dbLocation = join(appDirectory.path, dbName);
    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertData(Appointments statement) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");
    var keyID = store.add(db, {
      "frist": statement.fristname,
      "last": statement.lastname,
      "date": statement.date,
      "Time" : statement.selectedTime
    });
    db.close();
    return keyID;
  }

  Future<List<Appointments>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store("expense");
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));
    List<Appointments> appointmentsList = [];

    for (var record in snapshot) {
      appointmentsList.add(Appointments(
          fristname: record["frist"].toString(),
          lastname: record["last"].toString(),
          date: record["date"].toString(),
          selectedTime: record["Time"].toString(), 
          

      ));
    }
    return appointmentsList;
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
