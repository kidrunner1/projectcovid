import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracker_covid_v1/screen/adminscreen/vaccine/details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker_covid_v1/screen/adminscreen/vaccine/historyr_vaccine.dart';

class GetDataVaccineAdmin extends StatefulWidget {
  const GetDataVaccineAdmin({Key? key}) : super(key: key);

  @override
  State<GetDataVaccineAdmin> createState() => _GetDataVaccineAdminState();
}

class _GetDataVaccineAdminState extends State<GetDataVaccineAdmin> {
  final _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> vaccineStream;

  @override
  void initState() {
    super.initState();
    vaccineStream = _firestore.collection('vaccine_detail').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "การนัดฉีดวัคซีน",
          style: GoogleFonts.prompt(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[300],
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.history), // <-- FontAwesome Icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HisToryVaccineAdmin(), // <-- Your new page route
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: vaccineStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Something went wrong",
                style: GoogleFonts.prompt(fontSize: 18),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset('assets/animations/loading.json'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final vaccineData = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.redAccent.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VaccineDetailsPage(
                            vaccineData:
                                vaccineData.data() as Map<String, dynamic>,
                          ),
                        ),
                      );
                    },
                    splashColor: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      title: Text(
                        vaccineData['vaccineName'] ?? 'Unknown Vaccine',
                        style: GoogleFonts.prompt(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        vaccineData['vaccineDate'] ?? 'No date provided',
                        style: GoogleFonts.prompt(fontSize: 18),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.red[300],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
