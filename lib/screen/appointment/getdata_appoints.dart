import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_covid_v1/feture/news_screen.dart';

class GetdataAppoints extends StatefulWidget {
  final Map<String,dynamic> getappoints;

 const GetdataAppoints({Key? key, required this.getappoints}) : super(key: key);

  @override
  _GetdataAppointsState createState() => _GetdataAppointsState();
}

class _GetdataAppointsState extends State<GetdataAppoints> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
    );
    const TextStyle _textStyle = TextStyle(fontSize: 18);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("รายละเอียดการนัดรับยา"),
          elevation: 0,
          backgroundColor: Colors.red[300],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NewsScreens()),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Text(
                          "วันที่เข้ารับยา :${widget.getappoints['date'] ?? 'Not available'}", 
                          style: _textStyle,
                        ),
                      const SizedBox(height: 20),
                      Text(
                        "เวลา :${widget.getappoints['time'] ?? 'Not available'}",
                        style: _textStyle,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "ชื่อ : ${widget.getappoints['first_name'] ?? 'Not available'}  ${widget.getappoints['last_name'] ?? 'Not available'}",
                        style: _textStyle,
                      ),
                      ],
                    ),
                  ),
                ),
              ),const Divider(height: 20),

            ],
          ),
        ),
        backgroundColor: Colors.red[50],
      ),
    );
  }
}
