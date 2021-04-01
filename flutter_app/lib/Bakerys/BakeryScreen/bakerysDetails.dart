import 'package:flutter_app/Bakerys/BakeryScreen/bakerys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bakerys/Weichardt/components/list.dart';

class BakerysDetails extends StatefulWidget {
  final Bakery bakery;

  const BakerysDetails({
    Key key,
    @required this.bakery,
  }) : super(key: key);

  @override
  _BakerysDetailsState createState() => _BakerysDetailsState();
}

class _BakerysDetailsState extends State<BakerysDetails>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
            tag: "background_${widget.bakery.title}",
            child: Container(
              color: Color(widget.bakery.color),
            )),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color(widget.bakery.color),
            elevation: 0,
            title: Text(widget.bakery.title),
            leading: CloseButton(),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListPage()));
                  },
                  child: Hero(
                    tag: "image_${widget.bakery.title}",
                    child: Image.asset(
                      widget.bakery.link,
                      width: MediaQuery.of(context).size.height / 2,
                      height: 100,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, widget) => Transform.translate(
                    transformHitTests: false,
                    offset: Offset.lerp(
                        Offset(0.0, 200.0), Offset.zero, _controller.value),
                    child: widget,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
