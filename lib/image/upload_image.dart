import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:maps_task/home-screen.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  bool _uploading = false;
  String uniqueFileName= DateTime.now().millisecondsSinceEpoch.toString();

  ImagePicker picker = ImagePicker();

  Future<void> _selectImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    setState(() {
      _uploading = true;
    });

    try {
      if (_image != null) {
        String? fileExtension = _image!.path.split('.').last;
        String fileName = '$uniqueFileName.$fileExtension';

        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref(fileName);
        firebase_storage.UploadTask uploadTask = ref.putFile(
          _image!,
          firebase_storage.SettableMetadata(
            contentType: 'image/$fileExtension',
            customMetadata: <String, String>{
              'uploaded_by': 'user_id',
              'timestamp': DateTime.now().toString(),
            },
          ),
        );

        await Future.value(uploadTask);

        // Get the download URL
        String downloadURL = await ref.getDownloadURL();

        setState(() {
          _uploading = false;
          _image = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image uploaded successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an image first.'),
          ),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _uploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image. Please try again later.'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Storage and Google-Map',style: TextStyle(color: Colors.deepPurple,fontSize: 18),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(
              _image!,
              height: 200,
              width: 200,
            )
                : Placeholder(
              child: Image(image: AssetImage('assets/images/background.png')),
              fallbackHeight: 200,
              fallbackWidth: double.infinity,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectImage,
              child: Text('Select Image from Gallery'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploading ? null : _uploadImage,
              child: _uploading
                  ? CircularProgressIndicator()
                  : Text('Upload Image to Firebase'),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=>HomeScreen()));
              },
              child: Text('Go to Google Map'),
            ),
          ],
        ),
      ),
    );
  }
}
