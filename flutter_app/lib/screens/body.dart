import 'package:flutter_app/Bakerys/Weichardt/components/list.dart';
import 'package:flutter_app/Bakerys/Weichardt/weichShop.dart';
import 'package:flutter_app/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/HomeScreen.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreenMaps()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding:
                        EdgeInsets.symmetric(horizontal: 170, vertical: 75),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Weich/a.png"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(95),
                      border:
                          Border.all(color: Colors.blueGrey.withOpacity(0.32)),
                      /*boxShadow: [
                        new BoxShadow(
                            color: Colors.brown[200], offset: new Offset(5, 5)),
                      ],*/
                    ),
                  ),
                ),
                Text(
                  "Weichardt-Brot",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WeichShop()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    padding:
                        EdgeInsets.symmetric(horizontal: 170, vertical: 75),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Beumer.jpg"),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border:
                          Border.all(color: ksecondaryColor.withOpacity(0.32)),
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.orange[100],
                            offset: new Offset(5, 5)),
                      ],
                    ),
                  ),
                ),
                Text(
                  "Beumer & Lutum Bäckerei",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.symmetric(horizontal: 170, vertical: 75),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/Christa.jpg"),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border:
                        Border.all(color: ksecondaryColor.withOpacity(0.32)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.blue[100], offset: new Offset(5, 5)),
                    ],
                  ),
                  //child: ,
                ),
                Text(
                  "Christa Lutum Bäckermeisterin",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
