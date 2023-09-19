
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/model/check.dart';

import '../database/db_check.dart';

class CheckProvider with ChangeNotifier {
  List<CheckModel> check = [ ];

  List<CheckModel> getCheckModel() {
    return check;
  }

  void addCheckModel(CheckModel report) async {
    var db = CheckDB(namedb: "check.db");
    await db.insertData(report);

    check = await db.loadAllData();
    notifyListeners();
  }

  void deleteCheckModel(int index) {
    if (index < 0 || index >= check.length) return;
    check.removeAt(index);
    notifyListeners();
  }

  void initData() async {
    var db = CheckDB(namedb: "check.db");
    check = await db.loadAllData();
    notifyListeners();
  }

void editCheckModel(CheckModel editedCheck) {
  
  final index = check.indexWhere((check) =>
      check.date == editedCheck.date &&
      check.time == editedCheck.time &&
      check.weight == editedCheck.weight &&
      check.temp == editedCheck.temp&&
      check.type == editedCheck.type);

  if (index != -1) {
    // หากพบข้อมูลที่ต้องการแก้ไขในรายการ appointments
    check[index] = editedCheck; // ทำการอัปเดตข้อมูล
    notifyListeners(); // แจ้งเตือนให้ Widgets ที่กำลังฟังการเปลี่ยนแปลงจะทราบถึงการเปลี่ยนแปลงนี้
  }
}

}
