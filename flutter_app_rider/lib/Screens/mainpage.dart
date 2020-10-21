import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_rider/brand_colors.dart';
import 'package:flutter_app_rider/styles/styles.dart';
import 'package:flutter_app_rider/widgets/BrandDivider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:outline_material_icons/outline_material_icons.dart';


class MainPage extends StatefulWidget {

  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  double searchSheetHeight = (Platform.isIOS) ? 300 : 275;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapButtonPadding = 0;

  var geoLocator = GeolocatorPlatform.instance ;

  Position currentPosition;

  void setupPositionLocator() async{
    Position position = await geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    print(position);
    print(currentPosition);

      LatLng pos = LatLng(position.latitude, position.longitude);
      CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
      mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
  }


  static final CameraPosition _KGooglePlex = CameraPosition(
    target: LatLng(34.083656, 74.797371),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,

      //drawer
      drawer: Container(
        width: 250,
        color: Colors.white,
        child: Drawer(

          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[

              Container(
                color: Colors.white,
                height: 160,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.asset('images/user_icon.png',height: 60,width: 60,),
                      SizedBox(width: 15,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Ucheena',style: TextStyle(fontSize: 20,fontFamily: 'Brand-Bold'),),
                          SizedBox(height: 5,),
                          Text('View Profile'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              BrandDivider(),

              SizedBox(height: 10,),

              ListTile(
                leading: Icon(OMIcons.cardGiftcard),
                title: Text('Free Rides',style: kDrawerItemStyle),
              ),

              ListTile(
                leading: Icon(OMIcons.creditCard),
                title: Text('Payments',style: kDrawerItemStyle),
              ),

              ListTile(
                leading: Icon(OMIcons.history),
                title: Text('Ride History',style: kDrawerItemStyle),
              ),

              ListTile(
                leading: Icon(OMIcons.contactSupport),
                title: Text('Support',style: kDrawerItemStyle),
              ),

              ListTile(
                leading: Icon(OMIcons.info),
                title: Text('About',style: kDrawerItemStyle),
              ),

            ],
          ),
        ),
      ),

      //googlemap

      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapButtonPadding),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _KGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller){

              _controller.complete(controller);
              mapController = controller;

              setState(() {
                mapButtonPadding = (Platform.isAndroid) ?280 : 270;

              });
              setupPositionLocator();



            },
          ),

          ///menu-button
          Positioned(
            top: 44,
            left: 20,
            child: GestureDetector(
              onTap: (){
               scaffoldkey.currentState.openDrawer() ;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.menu,color: Colors.black87,),
                ),
              ),
            ),
          ),

          ///search sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: searchSheetHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                        0.7,
                        0.7
                    ),
                  ),
                ]
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5,),
                    Text('Nice to see you',style: TextStyle(fontSize: 15),),
                    Text('Where are you going?',style: TextStyle(fontSize: 18,fontFamily: 'Brand-Bold'),),

                    SizedBox(height: 20,),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                         BoxShadow(
                           color: Colors.black12,
                           blurRadius: 6.0,
                           spreadRadius: 0.5,
                           offset: Offset(
                             0.7,
                             0.7
                           ),
                         ),
                        ]

                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.search,color: Colors.blueAccent,),
                            SizedBox(width: 10,),
                            Text('Search Destination'),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 22,),

                    Row(
                      children: <Widget>[
                        Icon(OMIcons.home,color: BrandColors.colorDimText,),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Add Home'),
                            SizedBox(height: 3,),
                            Text('Your residential address',
                            style: TextStyle(fontSize: 11,color: BrandColors.colorDimText),
                            ),

                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),
                    BrandDivider(),
                    SizedBox(height: 16,),

                    Row(
                      children: <Widget>[
                        Icon(OMIcons.workOutline,color: BrandColors.colorDimText,),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Add Work'),
                            SizedBox(height: 3,),
                            Text('Your office address',
                              style: TextStyle(fontSize: 11,color: BrandColors.colorDimText),
                            ),

                          ],
                        ),
                      ],
                    ),



                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}


