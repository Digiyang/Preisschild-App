import 'package:flutter_app/Bakerys/BakeryScreen/bakerys.dart';
import 'package:flutter_app/Bakerys/BakeryScreen/bakerysDetails.dart';
import 'package:flutter/material.dart';

class ListBakery extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<ListBakery> {
  PageController _controller;

  _goToDetail(Bakery bakery) {
    final page = BakerysDetails(bakery: bakery);
    Navigator.of(context).push(
      PageRouteBuilder<Null>(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: page,
                  );
                });
          },
          transitionDuration: Duration(milliseconds: 400)),
    );
  }

  _listListener() {
    setState(() {});
  }

  @override
  void initState() {
    _controller = PageController(viewportFraction: 0.6);
    _controller.addListener(_listListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_listListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _controller,
          itemCount: bk.length,
          itemBuilder: (context, index) {
            double current = 0;
            try {
              current = _controller.page;
            } catch (_) {}

            final resize =
                (1 - (((current - index).abs() * 0.3).clamp(0.0, 1.0)));
            final currentBakery = bk[index];
            return ListItem(
              bakery: currentBakery,
              resize: resize,
              onTap: () => _goToDetail(currentBakery),
            );
          }),
    );
  }
}

class ListItem extends StatelessWidget {
  final Bakery bakery;
  final double resize;
  final VoidCallback onTap;

  const ListItem({
    Key key,
    @required this.bakery,
    @required this.resize,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.4;
    double width = MediaQuery.of(context).size.width * 0.85;
    return InkWell(
      onTap: onTap,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
            width: width * resize,
            height: height * resize,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: height / 4,
                  bottom: 0,
                  child: Hero(
                    tag: "background_${bakery.title}",
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Color(bakery.color),
                              Colors.white,
                            ],
                                stops: [
                              0.4,
                              1.0,
                            ])),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          margin: EdgeInsets.only(
                            left: 20,
                            bottom: 10,
                          ),
                          child: Text(
                            bakery.title,
                            style: TextStyle(
                              fontSize: 24 * resize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Hero(
                    tag: "image_${bakery.title}",
                    child: Image.asset(
                      bakery.link,
                      width: width / 2,
                      height: height,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
