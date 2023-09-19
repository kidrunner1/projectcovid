// import 'package:flutter/foundation.dart';
// import 'package:tracker_covid_v1/database/db_appoints.dart';
// import 'package:tracker_covid_v1/model/appoints.dart';

// class AppointmentsProvider with ChangeNotifier {
//   List<Appointments> appointments = [ ];

//   List<Appointments> getAppointments() {
//     return appointments;
//   }

//   void addAppointments(Appointments statement) async {
//     var db = AppointmentDB(dbName: "appointments.db");
//     await db.insertData(statement);

//     appointments = await db.loadAllData();
//     notifyListeners();
//   }
//   void deleteAppointments(int index) {
//     if (index < 0 || index >= appointments.length) return;
//     appointments.removeAt(index);
//     notifyListeners();
//   }

//   void initData() async {
//     var db = AppointmentDB(dbName: "appointments.db");
//     appointments = await db.loadAllData();
//     notifyListeners();
//   }

//   void deleteCheck(int index) {}


// }
