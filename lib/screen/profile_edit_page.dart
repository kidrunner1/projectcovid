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
  final _formKey = GlobalKey<FormState>(); // Added GlobalKey for Form
  String? _photoURL;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> saveInformation() async {
    if (_formKey.currentState!.validate()) {
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
                    "ตกลง",
                    style: GoogleFonts.prompt(fontSize: 16),
                  ),
                )
              ],
            );
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณาตรวจสอบข้อมูล')),
      );
    }
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
        backgroundColor:
            const Color(0xFFf6f6f6), // Changed background color to a soft gray.
        appBar: AppBar(
          title: Text("ข้อมูลส่วนตัว",
              style: GoogleFonts.prompt(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          backgroundColor:
              Colors.red[300], // Made the color slightly deeper for contrast.
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'แก้ไขข้อมูลส่วนตัว',
                        style: GoogleFonts.prompt(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius:
                                60, // Increased radius to make the profile picture bigger and more prominent.
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
                            bottom: 5,
                            right: 5,
                            child: CircleAvatar(
                              backgroundColor: Colors.red[300],
                              radius:
                                  25, // Increased radius to make the camera icon more visible.
                              child: IconButton(
                                icon: Icon(Icons.camera_alt,
                                    size: 25,
                                    color: Colors
                                        .white), // Increased icon size for better visibility.
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
                      _buildTextField(
                        controller: _phoneNumberController,
                        label: "เบอร์โทรศัพท์",
                        icon: Icons.phone,
                        inputType: TextInputType.number,
                        validator: (value) {
                          if (!RegExp(r'^0\d{9}$').hasMatch(value!)) {
                            return 'กรุณาใส่หมายเลขโทรศัพท์ที่ถูกต้อง';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: saveInformation,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[
                              300], // Match the color with the AppBar for consistency.
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical:
                                  15), // Increase padding for a larger button.
                        ),
                        child: Text(
                          'บันทึก',
                          style: GoogleFonts.prompt(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18), // Increase font size for emphasis.
                        ),
                      ),
                    ],
                  ),
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
    TextInputType? inputType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      style: GoogleFonts.prompt(fontSize: 16), // Apply the Google font here.
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.prompt(), // Apply the Google font here too.
        prefixIcon: Icon(icon,
            color:
                Colors.red[300]), // Use the same color as AppBar for the icon.
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.red[300]!)), // Color the border when focused.
        border: OutlineInputBorder(),
      ),
    );
  }
}
