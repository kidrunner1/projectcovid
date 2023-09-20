import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracker_covid_v1/screen/check_covid/details_chek.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormCheck extends StatefulWidget {
  const FormCheck({super.key});

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

  bool dataSaved = false; // Add this line

  Future<void> _saveToFirebase() async {
    String? imageUrl = await _uploadImageToFirebase(_image);
    await FirebaseFirestore.instance.collection('checkResults').add({
      'weight': weightinput.text,
      'temperature': tempinput.text,
      'result': typeinput,
      'timestamp': FieldValue.serverTimestamp(),
      if (imageUrl != null) 'imageUrl': imageUrl,
    });

    setState(() {
      dataSaved = true; // Update dataSaved to true once data is saved
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text('บันทึกผลตรวจโควิด-19 ประจำวัน'),
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: checkKey,
          child: Column(
            children: [
              _buildInputField(weightinput, "น้ำหนักปัจจุบัน", Icons.scale),
              const SizedBox(height: 20),
              _buildInputField(tempinput, "อุณหภูมิร่างกาย", Icons.thermostat),
              const SizedBox(height: 20),
              const Text(
                "ผลตรวจ ATK วันนี้",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        contentPadding: const EdgeInsets.all(0.0),
                        value: 'ผลเป็นลบ',
                        groupValue: typeinput,
                        activeColor: Colors.red[400],
                        title: const Text('ผลเป็นลบ'),
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
                        title: const Text('ผลเป็นบวก'),
                        onChanged: (val) {
                          setState(() {
                            typeinput = val!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_image != null) Image.file(_image!, height: 200, width: 200),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getImage,
                child: Row(
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 8),
                    Text("Upload Image")
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType
                        .SUCCES, // Note: It should be 'SUCCESS' not 'SUCCES'
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'สำเร็จ',
                    desc:
                        'พรุ่งนี้อย่าลืมมาบันทึกผลด้วยกันอีกนะ ... [rest of the description]',
                    btnOkOnPress: () {
                      // Here, after closing the dialog, you can navigate to the DetailsCheckScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DetailsCheckScreen(weight: '', temperature: '',)),
                      );
                    },
                  ).show();
                },
                child: Text("Save"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildInputField(
    TextEditingController controller, String label, IconData icon) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      validator: RequiredValidator(errorText: "กรุณาป้อน$label"),
    ),
  );
}
