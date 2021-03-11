import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/appBlocs.dart';
import 'package:flutter_app/template/where.dart';
import 'package:flutter_app/widgets/navigator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _googleMapsController = Completer();
  StreamSubscription whereSub;

  @override
  void initState() {
    final bloc = Provider.of<AppBlocs>(context, listen: false);

    whereSub = bloc.selection.stream.listen((where) {
      if (where != null) {
        _go(where);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    final bloc = Provider.of<AppBlocs>(context, listen: false);
    bloc.dispose();
    whereSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AppBlocs>(context);
    return Scaffold(
      //backgroundColor: Colors.deepOrangeAccent[100],
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Preisschild'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: (bloc.current == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: ' Search your Bakery ...',
                        suffix: Icon(Icons.search)),
                    onChanged: (value) => bloc.searching(value),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      height: 300.0,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                bloc.current.latitude, bloc.current.longitude),
                            zoom: 18),
                        onMapCreated: (GoogleMapController controller) {
                          _googleMapsController.complete(controller);
                        },
                      ),
                    ),
                    if (bloc.searchResponse != null &&
                        bloc.searchResponse.length != 0)
                      Container(
                        height: 300.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.6),
                            backgroundBlendMode: BlendMode.darken),
                      ),
                    if (bloc.searchResponse != null &&
                        bloc.searchResponse.length != 0)
                      Container(
                        height: 300.0,
                        child: ListView.builder(
                            itemCount: bloc.searchResponse.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  bloc.searchResponse[index].description,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  bloc.setSelection(
                                      bloc.searchResponse[index].placeId);
                                },
                              );
                            }),
                      )
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> _go(Somewhere where) async {
    final GoogleMapController controller = await _googleMapsController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                where.calibration.location.lat, where.calibration.location.lng),
            zoom: 18),
      ),
    );
  }
}
