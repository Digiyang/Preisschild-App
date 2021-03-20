import 'dart:ffi';

import 'package:flutter_app/Bakerys/Weichardt/components/category.dart';
import 'package:flutter_app/Bakerys/Weichardt/components/details.dart';
import 'package:flutter_app/Bakerys/Weichardt/screens/shopScreen.dart';
import 'package:flutter_app/screens/bar.dart';
import 'package:flutter_app/screens/components/searchBar.dart';
import 'package:flutter_app/widgets/navigator.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<ListPage> {
  PageController _controller;

  _goToDetail(Category category) {
    final page = Details(category: category);
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
  Void initState(){
    _controller = PageController(viewportFraction: 0.6);
    _controller.addListener(_listListener);
    super.initState();
  }

  @override 
  void dispose(){
    _controller.removeListener(_listListener);
    _controller.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    return 
        Scaffold(
          drawer: NavDrawer(),
          appBar: appBar(context),
          body:PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _controller,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              double current = 0;
              try {
                current = _controller.page;
              } catch(_) {}
              
              final resize = (1 - (((current - index).abs() * 0.3).clamp(0.0, 1.0)));
              final currentCategory = categories[index];
              return ListItem(
                category: currentCategory,
                resize: resize,
                onTap: () => _goToDetail(currentCategory),
              );
            }
          ),
        );        
  }
}

class ListItem extends StatelessWidget {

  final Category category;
  final double resize;
  final VoidCallback onTap;

  const ListItem({
    Key key,
    @required this.category,
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
                    tag: "background_${category.title}",
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
                              Color(category.color),
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
                            category.title,
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
                    tag: "image_${category.title}",
                    child: Image.asset(
                      category.link,
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
