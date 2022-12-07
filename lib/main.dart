import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String lat = '';
  String long = '';
  String location ='Null, Press Button';
  String Address = '';
  String regionstate = '';
  String regionCity = '';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {  
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      Address = '${place.street}, ${place.subLocality}, ${place.administrativeArea}, ${place.locality}, ${place.postalCode}, ${place.country}';
      regionstate = place.administrativeArea.toString();
      regionCity = place.locality.toString();
      lat = position.latitude.toString();
      long = position.longitude.toString();
    });
  }

  getlocation()async{
    Position position = await _getGeoLocationPosition();
    location ='Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Location",style: TextStyle(fontSize: 15),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:regionstate == '' ?  MainAxisAlignment.center : MainAxisAlignment.start,
          children: <Widget>[
            regionstate == '' ? ElevatedButton(
              onPressed: (){
                getlocation();
              }, 
              child: const Text("Get Your Location")
            ) : 
            const SizedBox(height: 20,),
            regionstate == '' ? const SizedBox() :
            regionstate == '' ? const SizedBox() : ListTile(
              minLeadingWidth: 0,
              leading: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.synagogue_outlined),
              ),
              title: const Text("State"),
              subtitle: Text(regionstate),
            ) ,
            const Divider(height: 1,),
            regionCity == '' ? const SizedBox() : ListTile(
              minLeadingWidth: 0,
              leading: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.location_city),
              ),
              title: const Text("City"),
              subtitle: Text(regionCity),
            ) ,
            const Divider(height: 1,),
            lat == '' ? const SizedBox() : ListTile(
              minLeadingWidth: 0,
              leading: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.zoom_out_map_outlined),
              ),
              title: const Text("Latitude"),
              subtitle: Text(lat),
            ) ,
            const Divider(height: 1,),
            long == '' ? const SizedBox() : ListTile(
              minLeadingWidth: 0,
              leading: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.zoom_out_map_outlined),
              ),
              title: const Text("Longitude"),
              subtitle: Text(long),
            ) ,
            const Divider(height: 1,),
            Address == '' ? const SizedBox() : ListTile(
              minLeadingWidth: 0,
              leading: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(Icons.  account_balance_outlined),
              ),
              title: const Text("Address"),
              subtitle: Text(Address),
            ) ,
            const Divider(height: 1,),
          ],
        ),
      ),
    );
  }
}
