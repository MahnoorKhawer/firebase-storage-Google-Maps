import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class OrderTracking extends StatefulWidget {
  const OrderTracking({super.key});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  final Completer<GoogleMapController> _controller=Completer();
  static const LatLng sourceLocation=LatLng(33.8584, 73.7654);
  static const LatLng destinationLocation=LatLng(33.8414, 73.7644);
  @override
  void initState(){
    super.initState();
    getPolyPoints();
    getCurrentLocation();
  }
  List<LatLng> polylineCoordinates=[];

  void getPolyPoints()async{
    PolylinePoints polylinePoints=PolylinePoints();
    PolylineResult result=await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyAKEFUSoyQRL_pPsZJNPC5yh0BM6PTv_Ok",
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destinationLocation.latitude, destinationLocation.longitude));
    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) =>polylineCoordinates.add(
        LatLng(point.latitude, point.longitude),
      ),);
      setState(() {});
    }
  }

  LocationData? currentLocation;
  void getCurrentLocation()async{
    Location location= Location();
    location.getLocation().then(
          (location){
        currentLocation=location;
      },
    );
    GoogleMapController googleMapController=await _controller.future;
    location.onLocationChanged.listen(
            (newLoc) {
          currentLocation=newLoc;
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 13.4,
                target: LatLng(
                  newLoc.latitude!,
                  newLoc.longitude!,
                ),
              ),
            ),
          );
          setState(() {});
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation==null? Center(child: CircularProgressIndicator()):
      GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        trafficEnabled: true,
        indoorViewEnabled: true,
        compassEnabled: true,
        //Map Gestures
        rotateGesturesEnabled: true,
        zoomControlsEnabled: true,
        tiltGesturesEnabled: true,
        scrollGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: 13.5,
        ),
        markers: {},
        onMapCreated: (mapController){
          _controller.complete(mapController);
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: const Color(0xFF7B61FF),
            width: 6,
          ),
        },
      ),
    );
  }
}