import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Place.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  List<Place> _nearPlaces = <Place>[];
  var places;
// on below line we have specified camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(20.42796133580664, 80.885749655962),
    zoom: 14.4746,
  );

// on below line we have created the list of markers
  List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(1.3733, 32.2903),
        infoWindow: InfoWindow(
          title: 'My Position',
        )),
  ];

// created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future AddNearbyMentalHealthCenter(double longitude, double latitude) async {
    String result =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=hospital&key=AIzaSyAV1Jk6WQnI9l3Rcqhq0AMWNxmVNJ7OI00';

    http.Response response = await http.get(Uri.parse(result), headers: {
      "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      "Referrer-Policy": "no-referrer-when-downgrade"
    });
    Map data = json.decode(response.body);

    setState(() {
      this.places = data['results'];
      for (var place in places) {
        String name = "UNKNOWN";
        String isOpen = "UNKNOWN";
        double rating = 0;
        try {
          name = place['name'];
        } catch (e) {
          name = "UNKNOWN";
        }

        try {
          rating = place['rating'];
        } catch (e) {
          rating = 0;
        }

        try {
          isOpen = place['opening_hours']['open_now'].toString();
        } catch (e) {
          isOpen = "UNKNOWN";
        }

        _nearPlaces.add(Place(name: name, isOpen: isOpen, rating: rating));

        _markers.add(Marker(
          markerId: MarkerId(place['place_id']),
          position: LatLng(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']),
          infoWindow: InfoWindow(
            title: place['name'],
            snippet: place['vicinity'],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(300),
        ));
      }
    });
  }

  Future LoadUserLocation() async {
    getUserCurrentLocation().then((value) async {
      _markers.clear();

      // marker added for current users location
      _markers.add(Marker(
        markerId: MarkerId("2"),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: 'My Current Location',
        ),
      ));
      AddNearbyMentalHealthCenter(value.longitude, value.latitude);

      // specified current users location
      CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      controller.setMapStyle(
          '[{"elementType": "labels.icon","stylers": [{ "color": "0xFFA58EFF" }]}, {"elementType": "labels.text.fill","stylers": [{ "color": "#000000" }]}]');
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    LoadUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: SafeArea(
              // on below line creating google maps
              child: GoogleMap(
                // on below line setting camera position
                initialCameraPosition: _kGoogle,
                // on below line we are setting markers on the map
                markers: Set<Marker>.of(_markers),
                // on below line specifying map type.
                mapType: MapType.normal,
                // on below line setting user location enabled.
                myLocationEnabled: true,
                // on below line setting compass enabled.
                compassEnabled: true,
                // on below line specifying controller on map complete.
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.08,
              minChildSize: 0.05,
              maxChildSize: 0.8,
              builder: (context, controller) => Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            const Center(
                              child: SizedBox(
                                width: 50,
                                child: Divider(thickness: 5),
                              ),
                            ),
                            const Text(
                              "Health centers near you",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        controller: controller,
                        itemCount: _nearPlaces.length,
                        itemBuilder: (context, index) {
                          final place = _nearPlaces[index];
                          return BuildPlace(place);
                        },
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  Widget BuildPlace(Place place) => Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(place.name,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(place.rating.toString()),
              RatingBar.builder(
                initialRating: place.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                ignoreGestures: true,
                itemSize: 20,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 10,
                ),
                onRatingUpdate: (rating) {},
              ),
            ],
          ),
          Text(" Is Open : " + place.isOpen, style: TextStyle(fontSize: 15))
        ],
      ));
}
