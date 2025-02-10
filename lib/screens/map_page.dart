import 'package:flutter/material.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapPage extends StatefulWidget {
 
  const MapPage({Key?key}):super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController>_controller = Completer();

  late BitmapDescriptor _locIcon;
  final Set<Marker> listMarkers = {};

  Future <BitmapDescriptor> _setLotCustomMarker() async {
    BitmapDescriptor bIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5), 'images/home-map-pin.png');
      return bIcon;
  }
  @override
  void initState(){
    super.initState();
    _setLotCustomMarker().then((value){
      _locIcon = value;

      // ignore: unnecessary_null_comparison
      _locIcon != null
        ? setState((){
          listMarkers.add(Marker(
            markerId: const MarkerId('1'),
              // position: LatLng(widget.userLocation!.latitude!,
              //   widget.userLocation!.longitude!),
             position: const LatLng(1.3851, 103.7449),
                infoWindow: const InfoWindow(title:'Current Location'),
                icon: _locIcon
          ));
        })
        :DoNothingAction();
    });
  }
  @override
  Widget build(BuildContext context) {
    CameraPosition currentPos = const CameraPosition(
      bearing: 0.0,
      target: LatLng(1.3851, 103.7449),
      tilt: 60.0,
      zoom: 13,
    );
    return Scaffold(
      body: GoogleMap(
     
        markers: Set.from(listMarkers),
        initialCameraPosition: currentPos,
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(1.3851, 103.7449),
                zoom: 16, 
              ),
            ),
          );
        },
        ),
    );
  }
}