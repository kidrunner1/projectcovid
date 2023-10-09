import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as Path;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tracker_covid_v1/screen/check_covid/details_chek.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormCheck extends StatefulWidget {
  @override
  State<FormCheck> createState() => _FormCheckState();
}

class _FormCheckState extends State<FormCheck> {
  final weightinput = TextEditingController();
  final tempinput = TextEditingController();
  String typeinput = '';
  final checkKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> _uploadImageToFirebase(File? image) async {
    if (image == null) return null;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('atk_results/${Path.basename(image.path)}');
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() => {});
    final url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _saveToFirebase() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Error!",
      desc: "No user found. Please login again.",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
    return;
  }

  String? imageUrl = await _uploadImageToFirebase(_image);
  await FirebaseFirestore.instance.collection('checkResults').add({
    'userID': currentUser.uid,
    'createdAt': Timestamp.now(),
    'weight': weightinput.text,
    'temperature': tempinput.text,
    'result': typeinput,
    'timestamp': FieldValue.serverTimestamp(),
    if (imageUrl != null) 'imageUrl': imageUrl,
  });

  Alert(
    context: context,
    type: AlertType.success,
    title: "บันทึกข้อมูลสำเร็จ",
     desc: 'พรุ่งนี้อย่าลืมมาบันทึกผลนะ\n คำแนะนำ!!!\n',
         style: AlertStyle(
        titleStyle: GoogleFonts.prompt(fontSize: 20.0, fontWeight: FontWeight.bold), // adjust the size as required
        descStyle: GoogleFonts.prompt(fontSize: 18.0), // adjust the size as required
    ),
    content: Text('1. แยกห้องพัก ของใช้ส่วนตัวกับผู้อื่น (หากแยกไม่ได้ ควรอยู่ให้ห่างจากผู้อื่นมากที่สุด)\n2. ห้ามออกจากที่พักและปฏิเสธผู้ใดมาเยี่ยมที่บ้าน\n3. หลีกเลี่ยงการรับประทานอาหารร่วมกัน\n4. สวมหน้ากากอนามัยตลอดเวลา หากไม่ได้อยู่คนเดียว\n5. เว้นระยะห่าง อย่างน้อย 2 เมตร\n6. แยกซักเสื้อผ้า รวมไปถึงควรใช้ห้องน้ำแยกจากผู้อื่น',
    style: GoogleFonts.prompt(fontSize: 14),),
    buttons: [
      DialogButton(
        child: Text(
          "ตกลง",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        color: Colors.green,
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => DetailsCheckScreen(),
            ),
          );
        },
        width: 120,
      )
    ],
  ).show();
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.red[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'บันทึกผลตรวจโควิด-19 ประจำวัน',
            style: GoogleFonts.prompt(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red[300],
          centerTitle: true,
          elevation: 8.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: checkKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                      weightinput, "น้ำหนักปัจจุบัน *", Icons.scale),
                  const SizedBox(height: 20),
                  _buildInputField(
                      tempinput,
                      "อาการไข้ (อุณหภูมิ ≥ 37.5 ° C) ระบุอุณหภูมิ ",
                      Icons.thermostat),
                  const SizedBox(height: 20),
                  Text(
                    "ผลตรวจ ATK วันนี้ *",
                    style: GoogleFonts.prompt(
                        color: Colors.blueGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  _buildRadioButtonGroup(),
                  const SizedBox(height: 20),
                  Text(
                    "แนบผลการตรวจ ATK (รูปภาพ) *",
                    style: GoogleFonts.prompt(
                      color: Colors.blueGrey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_image != null)
                    Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(_image!, fit: BoxFit.cover)),
                    ),
                  const SizedBox(height: 20),
                  _buildUploadButton(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButtonGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                contentPadding: const EdgeInsets.all(0.0),
                value: 'ผลเป็นลบ',
                groupValue: typeinput,
                activeColor: Colors.red[400],
                title: Text('ผลเป็นลบ', style: GoogleFonts.prompt()),
                onChanged: (val) {
                  setState(() {
                    typeinput = val!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                contentPadding: const EdgeInsets.all(0.0),
                value: 'ผลเป็นบวก',
                groupValue: typeinput,
                activeColor: Colors.red[400],
                title: Text('ผลเป็นบวก', style: GoogleFonts.prompt()),
                onChanged: (val) {
                  setState(() {
                    typeinput = val!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: RequiredValidator(errorText: "$label is required"),
        keyboardType: TextInputType.number,
        style: GoogleFonts.prompt(fontSize: 18, color: Colors.blueGrey[900]),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.prompt(),
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue[400]!),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.upload),
      label: Text("อัพโหลดรูปภาพ", style: GoogleFonts.prompt(fontSize: 18)),
      onPressed: _getImage,
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCustomButton(
            "บันทึกข้อมูล", Icons.save, Colors.blueGrey[700]!, _saveToFirebase),
        _buildCustomButton("ยกเลิก", Icons.cancel, Colors.red[400]!, () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DetailsCheckScreen()));
        }),
      ],
    );
  }

  Widget _buildCustomButton(
      String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(text, style: GoogleFonts.prompt(fontSize: 16)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
