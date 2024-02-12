import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maps_task/image/upload_image.dart';

import 'firebase_options.dart';
import 'home-screen.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(mygooglemap());
}
class mygooglemap extends StatelessWidget {
  const mygooglemap({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:ImageUploadScreen(),
      ),
    );
  }
}