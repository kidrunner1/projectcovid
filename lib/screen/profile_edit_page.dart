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
  final _formKey = GlobalKey<FormState>();
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
    return SafeArea(
      child: LoadingOverlay(
        isLoading: isLoading,
        child: Scaffold(
          backgroundColor: Colors.red[50],
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red[50]!,
                  Colors.red[50]!,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.blueGrey.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.red[300],
                                  ))
                            ],
                          ),
                          Text(
                            'แก้ไขข้อมูลส่วนตัว',
                            style: GoogleFonts.prompt(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey.shade800),
                          ),
                          const SizedBox(height: 30),
                          _buildProfilePicture(),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _firstNameController,
                            label: "ชื่อ",
                            icon: FontAwesomeIcons.userAlt,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _lastNameController,
                            label: "นามสกุล",
                            icon: FontAwesomeIcons.userAlt,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _phoneNumberController,
                            label: "เบอร์โทรศัพท์",
                            icon: FontAwesomeIcons.phone,
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
                              primary: Colors.red[300],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                            ),
                            child: Text(
                              'บันทึก',
                              style: GoogleFonts.prompt(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
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
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: Colors.grey[300],
          backgroundImage: _photoURL != null ? NetworkImage(_photoURL!) : null,
          child: _photoURL == null
              ? Icon(FontAwesomeIcons.userCircle,
                  color: Colors.red[300], size: 70)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red[300],
            ),
            child: IconButton(
              icon:
                  Icon(FontAwesomeIcons.camera, size: 25, color: Colors.white),
              onPressed: selectImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.prompt(fontSize: 18),
        prefixIcon: Icon(icon, color: Colors.blueGrey.shade600),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey.shade800, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.red.shade600),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.red.shade800),
        ),
      ),
    );
  }
}
