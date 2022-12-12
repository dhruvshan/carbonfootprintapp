import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

class GoogleMapsPage extends StatefulWidget {
  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPage();
}

class _GoogleMapsPage extends State<GoogleMapsPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(1.2921971, 103.8042835);

  GoogleMapController? _googleMapController;

  LocationData? currentLocation;

  @override
  void dispose() {
    if (_googleMapController != null) {
      _googleMapController!.dispose();
    }
    super.dispose();
  }

  BitmapDescriptor icon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
  }

  final Set<Marker> markers = new Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map',
            style: TextStyle(color: Color.fromARGB(238, 248, 240, 227))),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 35, 59, 37),
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(1.2921971, 103.8042835), zoom: 10.5),
        markers: getmarkers(),
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
    );
  }
//Had to add data recently as iFrame data stopped working
  Set<Marker> getmarkers() {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(sourceLocation.toString()),
        position: sourceLocation,
        infoWindow: InfoWindow(
          title: 'My Home ',
          snippet: 'Queenstown',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      markers.add(Marker(
        markerId: MarkerId(sourceLocation.toString()),
        position: LatLng(1.34671615696183, 103.945521390894996),
        infoWindow: InfoWindow(
          title: 'Tampines Street 11',
          snippet: '521102',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      markers.add(Marker(
        markerId: MarkerId(sourceLocation.toString()),
        position: LatLng(1.35401863808222, 103.958966327804006),
        infoWindow: InfoWindow(
          title: 'Tampines Street 32',
          snippet: '520381',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      markers.add(Marker(
        markerId: MarkerId(sourceLocation.toString()),
        position: LatLng(1.43998365879759, 103.801293109040003),
        infoWindow: InfoWindow(
          title: 'Woodlands Avenue 6',
          snippet: '730678',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      markers.add(Marker(
        markerId: MarkerId(sourceLocation.toString()),
        position: LatLng(1.39566918393033, 103.745726065653997),
        infoWindow: InfoWindow(
          title: 'Choa Chu Kang Street 52',
          snippet: '680563',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      markers.add(Marker(
        markerId: MarkerId(sourceLocation.toString()),
        position: LatLng(1.39566918393033, 103.745726065653997),
        infoWindow: InfoWindow(
          title: 'Choa Chu Kang Street 52',
          snippet: '680563',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      markers.add(Marker(
        markerId: MarkerId(sourceLocation.toString()),
        position: LatLng(1.27590520940023, 103.842741250241005),
        infoWindow: InfoWindow(
          title: 'Tanjong Pagar Plaza',
          snippet: '81004',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      markers.add(Marker(
        markerId: MarkerId(sourceLocation.toString()),
        position: LatLng(1.31032016918551, 103.760411567915995),
        infoWindow: InfoWindow(
          title: 'West Coast Drive',
          snippet: '120511',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    return markers;
  }
}
