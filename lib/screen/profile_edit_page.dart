import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _photoURL;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }
  Future<void> saveInformation() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .update({
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'phoneNumber': _phoneNumberController.text.trim(),
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "แจ้งเตือน ",
              style: GoogleFonts.prompt(fontSize: 20),
            ),
            content: Text(
              "แก้ไขข้อมูลเรียบร้อย",
              style: GoogleFonts.prompt(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: GoogleFonts.prompt(fontSize: 16),
                ),
              )
            ],
          );
        });
  }

  Future<void> fetchInitialData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get();
    Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;
    _firstNameController.text = userData['firstName'];
    _lastNameController.text = userData['lastName'];
    _phoneNumberController.text = userData['phoneNumber'] ?? ''; 
    setState(() {
      _photoURL = userData['photoURL'];
    });
  }

  Future<void> selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      String filePath = 'profile_pics/${_auth.currentUser!.uid}.png';
      await FirebaseStorage.instance.ref(filePath).putFile(image);
      String newPhotoURL =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
      setState(() {
        _photoURL = newPhotoURL;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .update({'photoURL': newPhotoURL});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            "ข้อมูลส่วนตัว",
            style: GoogleFonts.prompt(color: Colors.white),
          ),
          backgroundColor: Colors.red[300],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'แก้ไขข้อมูลส่วนตัว',
                      style: GoogleFonts.prompt(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          backgroundImage: _photoURL != null
                              ? NetworkImage(_photoURL!)
                              : null,
                          child: _photoURL == null
                              ? Icon(FontAwesomeIcons.camera,
                                  color: Colors.white, size: 50)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.red[300],
                            radius: 20,
                            child: IconButton(
                              // ignore: prefer_const_constructors
                              icon: Icon(Icons.camera_alt,
                                  size: 20, color: Colors.white),
                              onPressed: selectImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _firstNameController,
                      label: "ชื่อ",
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _lastNameController,
                      label: "นามสกุล",
                      icon: Icons.person_outline,
                    ),
                     const SizedBox(height: 20),
                    _buildTextField(  // Add the phone number input field
                      controller: _phoneNumberController,
                      label: "เบอร์โทรศัพท์",
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: saveInformation,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.red[300],
                      ),
                      
                      child: Text(
                        'บันทึก',
                        style: GoogleFonts.prompt(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.blueGrey[800]),
        labelText: label,
        labelStyle: GoogleFonts.prompt(
            fontWeight: FontWeight.w500, color: Colors.blueGrey[800]),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
