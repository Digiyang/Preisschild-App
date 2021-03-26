import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bakerys/Weichardt/components/list.dart';
import 'package:flutter_app/blocs/appBlocs.dart';
import 'package:flutter_app/screens/bar.dart';
import 'package:flutter_app/template/where.dart';
import 'package:flutter_app/widgets/navigator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreenMaps extends StatefulWidget {
  HomeScreenMaps({Key key}) : super(key: key);
  @override
  _HomeScreenMapsState createState() => _HomeScreenMapsState();
}

class _HomeScreenMapsState extends State<HomeScreenMaps> {
  Completer<GoogleMapController> _googleMapsController = Completer();
  StreamSubscription whereSub;
  StreamSubscription wherePin;

  @override
  void initState() {
    final bloc = Provider.of<AppBlocs>(context, listen: false);

    whereSub = bloc.selection.stream.listen((where) {
      if (where != null) {
        _go(where);
      }
    });

    wherePin = bloc.bounds.stream.listen((bounds) async {
      final GoogleMapController controller = await _googleMapsController.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
    });

    super.initState();
  }

  @override
  void dispose() {
    final bloc = Provider.of<AppBlocs>(context, listen: false);
    bloc.dispose();
    wherePin.cancel();
    whereSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<AppBlocs>(context);
    return Scaffold(
      //backgroundColor: Colors.deepOrangeAccent[100],
      drawer: NavDrawer(),
      appBar: appBar(context),
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
                      height: 500.0,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        markers: Set<Marker>.of(bloc.pins),
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
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Nearst Places',
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: [
                      FilterChip(
                        label: Text('Bakery'),
                        onSelected: (val) => bloc.toggleArea('bakery', val),
                        selected: bloc.area == 'bakery',
                        selectedColor: Colors.orangeAccent,
                      ),
                      FilterChip(
                        label: Text('ATM'),
                        onSelected: (val) => bloc.toggleArea('atm', val),
                        selected: bloc.area == 'atm',
                        selectedColor: Colors.green,
                      ),
                      FilterChip(
                        label: Text('Bank'),
                        onSelected: (val) => bloc.toggleArea('bank', val),
                        selected: bloc.area == 'bank',
                        selectedColor: Colors.greenAccent,
                      ),
                      FilterChip(
                        label: Text('Cafe'),
                        onSelected: (val) => bloc.toggleArea('cafe', val),
                        selected: bloc.area == 'cafe',
                        selectedColor: Colors.brown,
                      ),
                      FilterChip(
                        label: Text('Store'),
                        onSelected: (val) => bloc.toggleArea('store', val),
                        selected: bloc.area == 'store',
                        selectedColor: Colors.red,
                      ),
                      FilterChip(
                        label: Text('Drugstore'),
                        onSelected: (val) => bloc.toggleArea('drugstore', val),
                        selected: bloc.area == 'drugstore',
                        selectedColor: Colors.redAccent,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            primary: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Text(
                              "Access Shop",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
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
