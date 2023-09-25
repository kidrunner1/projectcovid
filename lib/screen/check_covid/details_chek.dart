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

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print("Current User's UID: $userId"); // Debugging print
    if (userId != null) {
      _stream = FirebaseFirestore.instance
          .collection('checkResults')
          .where('userID', isEqualTo: userId)
          .orderBy('createdAt', descending: false)
          .snapshots();
    }
  }

  bool canAddMoreRecords(List<DocumentSnapshot> docs) {
    final today = DateTime.now();
    int count = 0;
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('createdAt')) {
        final createdAt = (data['createdAt'] as Timestamp).toDate();
        if (createdAt.year == today.year &&
            createdAt.month == today.month &&
            createdAt.day == today.day) {
          count++;
        }
      }
    }
    return count < 3;
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
      iconTheme: IconThemeData(color: Colors.pink[50]),
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
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                docsNotifier.value = docs;
              });

              if (docs.isEmpty) {
                return const Center(
                    child: Text(
                  "กรุณาทำการบันทึก\nผลตรวจประจำวัน",
                  style: TextStyle(fontSize: 25),
                ));
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      title: Text(
                        'บันทึกครั้งที่  ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetDataCheckScreen(
                                data:
                                    docs[index].data() as Map<String, dynamic>),
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
                        height: 250, // Set the height you desire here
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons
                                  .error_outline, // This is a yellow shocked icon
                              color: Colors.yellow,
                              size: 70, // Adjust size as needed
                            ),
                            const SizedBox(
                                height: 20), // Spacing between icon and text
                            const Text(
                              'วันนี้คุณได้บันทึกผลตรวจประจำวันครบ\nแล้วพรุ้งนี้อย่าลืมมาบันทึกผลกันใหม่นะ.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            const Expanded(
                                child:
                                    SizedBox()), // This will push everything above to the top
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10), // Padding from the bottom
                                child: ElevatedButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.green),
                                  ),
                                  child: const Text('ตกลง'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
              child: const Icon(Icons.edit),
              backgroundColor: docs.isEmpty || canAddMoreRecords(docs)
                  ? theme.floatingActionButtonTheme.backgroundColor
                  : Colors.grey,
            );
          },
        ),
        backgroundColor: Colors.pink[50],
      ),
    );
  }
}
