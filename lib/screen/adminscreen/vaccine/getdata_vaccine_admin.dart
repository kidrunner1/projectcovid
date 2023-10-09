import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Vaccine/details.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:tracker_covid_v1/screen/adminscreen/Vaccine/historyr_vaccine.dart';

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
            icon: Icon(FontAwesomeIcons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HisToryVaccineAdmin(),
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

          final vaccineDocs = snapshot.data?.docs;

          return AnimationLimiter(
            child: ListView.builder(
              itemCount: vaccineDocs?.length,
              itemBuilder: (context, index) {
                final vaccineData =
                    vaccineDocs?[index].data() as Map<String, dynamic>;

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
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
                                    vaccineData: vaccineData,
                                  ),
                                ),
                              );
                            },
                            splashColor: Colors.redAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                title: Text(
                                  vaccineData['username'] ?? 'Unknown Vaccine',
                                  style: GoogleFonts.prompt(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      vaccineData['vaccineRound'] ??
                                          'No vaccine name provided',
                                      style: GoogleFonts.prompt(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      vaccineData['vaccineDate'] ??
                                          'No date provided',
                                      style: GoogleFonts.prompt(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
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
    );
  }
}
