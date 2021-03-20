import 'package:bakery/Bakerys/Weichardt/components/category.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {

  final Category category;

  const Details({
    Key key,
    @required this.category,
  }): super (key: key);

  @override
  _DetailsState createState() => _DetailsState();
  }

 class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
      
    AnimationController _controller;

    @override
    void initState() {
      _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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
            tag: "background_${widget.category.title}", 
            child: Container(
              color: Color(widget.category.color),
              )
            ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Color(widget.category.color),
              elevation: 0,
              title: Text(widget.category.title),
              leading: CloseButton(),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: "image_${widget.category.title}", 
                    child: Image.asset(
                     widget.category.link,
                     height: MediaQuery.of(context).size.height / 2, 
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
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          widget.category.details,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
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