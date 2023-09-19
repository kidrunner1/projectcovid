import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/record_daily.dart';

class Key_data extends StatefulWidget {
  const Key_data({super.key});

  @override
  State<Key_data> createState() => _Key_dataState();
}

class _Key_dataState extends State<Key_data> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    var card = Container(
      height: 100,
      child: const Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: ListTile(
          dense: false,
          title: Text(
            "บันทึกผลวันที่ 1",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: Text(
            "Instructor: Mustafa Tahir",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        title: Text("ผลการตรวจโควิด-19 ประจำวัน"),
        backgroundColor: Color.fromARGB(255, 239, 154, 154),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                card,
                card,
                card,
                card,
                card,
                card,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.black,
          backgroundColor: Colors.red[50],
          highlightElevation: 40,
          elevation: 12,
          tooltip: 'เพิ่ม',
          child: Icon(Icons.add),
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => Memo(),
            //     ));
          }),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.pink[800]),
        ),
        child: CurvedNavigationBar(
          index: index,
          height: 60.0,
          items: const <Widget>[
            Icon(
              Icons.home_filled,
              size: 30,
            ),
            Icon(Icons.message_outlined, size: 30),
            Icon(Icons.settings, size: 30),
            Icon(Icons.person_rounded, size: 30),
          ],
          color: Color.fromARGB(255, 239, 154, 154),
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.red[200],
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              this.index = index;
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
