import 'package:flutter_app/const.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final ValueChanged<String> onChange;
  const SearchBar({
    Key key, this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: ksecondaryColor.withOpacity(0.32)), 
        ),
      child: TextField(
        onChanged: onChange,
        decoration: InputDecoration(border: InputBorder.none,
        icon: Image.asset("assets/images/icons8-search.gif", height: 40, width: 40,),
        hintText: "Search Here ...",
        ),
      ),
    );
  }
}
