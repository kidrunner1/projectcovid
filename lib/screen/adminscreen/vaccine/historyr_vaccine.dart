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

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final historyData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          title: Text(
                            historyData['username'] ?? 'Unknown User',
                            style: GoogleFonts.prompt(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                historyData['vaccineName'] ?? 'Unknown Vaccine',
                                style: GoogleFonts.prompt(fontSize: 18),
                              ),
                              SizedBox(height: 5),
                              Text(
                                historyData['vaccineDate'] ??
                                    'No date provided',
                                style: GoogleFonts.prompt(fontSize: 16),
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.verified, color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
