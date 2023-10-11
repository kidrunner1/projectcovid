import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HisToryVaccineAdmin extends StatefulWidget {
  const HisToryVaccineAdmin({super.key});

  @override
  State<HisToryVaccineAdmin> createState() => _HisToryVaccineAdminState();
}

class _HisToryVaccineAdminState extends State<HisToryVaccineAdmin> {
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> historyStream;

  @override
  void initState() {
    super.initState();
    historyStream = _firestore.collection('vaccineHistory').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "ยืนยันการฉีดวัคซีน",
            style: GoogleFonts.prompt(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[300],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: historyStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Something went wrong",
                  style: GoogleFonts.prompt(fontSize: 18),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return AnimationLimiter(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final historyData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.red.shade900,
                                    Colors.red[300]!,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: ListTile(
                                title: Text(
                                  'ชื่อ - นามสกุล: ${historyData['username']}',
                                  style: GoogleFonts.prompt(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  'วัคซีน: ${historyData['vaccineName']} \nวันที่: ${historyData['vaccineDate']}',
                                  style: GoogleFonts.prompt(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: Icon(Icons.verified,
                                    color: Colors.green, size: 30.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
