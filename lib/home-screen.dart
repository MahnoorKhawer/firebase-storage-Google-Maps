import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_task/image/upload_image.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder:(context)=>ImageUploadScreen()));
            },
            icon: Icon(Icons.arrow_back,color: Colors.black,size: 24,)),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller){
          _controller=controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(33.6844, 73.0479),
          zoom: 14,
        ),
        mapType: MapType.normal,
        markers: <Marker>{
          const Marker(
            markerId: MarkerId('marker 1'),
            position: LatLng(33.6844, 73.0479),
            infoWindow: InfoWindow(title: 'marker 2'),),
        },
      ),
    );

  }
}