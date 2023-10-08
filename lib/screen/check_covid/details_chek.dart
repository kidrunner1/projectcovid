import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_covid_v1/screen/check_covid/form_check.dart';
import 'package:tracker_covid_v1/screen/check_covid/getdata_check.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsCheckScreen extends StatefulWidget {
  @override
  _DetailsCheckScreenState createState() => _DetailsCheckScreenState();
}

class _DetailsCheckScreenState extends State<DetailsCheckScreen> {
  Stream<QuerySnapshot>? _stream;
  final ValueNotifier<List<DocumentSnapshot>> docsNotifier =
      ValueNotifier<List<DocumentSnapshot>>([]);
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _stream = FirebaseFirestore.instance
          .collection('checkResults')
          .where('userID', isEqualTo: userId)
          .orderBy('createdAt', descending: false)
          .snapshots();
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool canAddMoreRecords(List<DocumentSnapshot> docs) {
    final today = DateTime.now();
    int count = 0;
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('createdAt')) {
        final createdAt = (data['createdAt'] as Timestamp).toDate();
        if (isSameDay(createdAt, today)) {
          count++;
        }
      }
    }
    return count < 3;
  }

  Map<String, List<DocumentSnapshot>> _groupByDate(
      List<DocumentSnapshot> docs) {
    Map<String, List<DocumentSnapshot>> groupedData = {};
    for (var doc in docs) {
      final date = (doc['createdAt'] as Timestamp)
          .toDate()
          .toIso8601String()
          .split('T')[0];
      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(doc);
    }
    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
      primaryColor: Colors.red[300],
      hintColor: Colors.red[300],
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.red[300],
      ),
      iconTheme: IconThemeData(color: Colors.red[50]),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ผลตรวจโควิด-19 ประจำวัน"),
          elevation: 0,
          centerTitle: true,
          backgroundColor: theme.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("Firestore Error: ${snapshot.error}");
                return const Center(child: Text("มีบางอย่างผิดพลาด"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data?.docs ?? [];
              WidgetsBinding.instance.addPostFrameCallback((_) {
                docsNotifier.value = docs;
              });

              if (docs.isEmpty) {
                return const Center(
                    child: Text("กรุณาทำการบันทึก\nผลตรวจประจำวัน",
                        style: TextStyle(fontSize: 25)));
              }

              final groupedData = _groupByDate(docs);

              return ListView.builder(
                itemCount: groupedData.length,
                itemBuilder: (context, index) {
                  final date = groupedData.keys.elementAt(index);
                  final data = groupedData[date]!;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      leading: Icon(
                        Icons.calendar_month,
                        size: 50,
                        color: Colors.red[300],
                      ),
                      title: Text('บันทึกวันที่  $date',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.red[300],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetDataCheckScreen(
                              data: data[0].data() as Map<String, dynamic>,
                              userId: userId ?? '',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        //backgroundColor: Colors.red[50],
        floatingActionButton: ValueListenableBuilder<List<DocumentSnapshot>>(
          valueListenable: docsNotifier,
          builder: (context, docs, child) {
            return FloatingActionButton(
              onPressed: () {
                if (docs.isEmpty || canAddMoreRecords(docs)) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => FormCheck()));
                } else if (!canAddMoreRecords(docs)) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      content: Container(
                        height: 250,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.yellow, size: 70),
                            SizedBox(height: 20),
                            Text(
                                'วันนี้คุณได้บันทึกผลตรวจประจำวันครบ\nแล้วพรุ้งนี้อย่าลืมมาบันทึกผลกันใหม่นะ.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text("ตกลง",
                              style: TextStyle(
                                color: Colors.blue,
                              )),
                        ),
                      ],
                    ),
                  );
                }
              },
              tooltip: 'บันทึกผลตรวจโควิด-19',
              child: const Icon(Icons.edit),
            );
          },
        ),
      ),
    );
  }
}
