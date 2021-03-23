import 'package:flutter/material.dart';
import 'package:flutter_app/Bakerys/Weichardt/components/productList.dart';

class WeichProdDetails extends StatefulWidget {
  const WeichProdDetails({Key key, @required this.product, this.onAdded})
      : super(key: key);
  final WeichProduct product;
  final VoidCallback onAdded;

  @override
  _WeichProdDetailsState createState() => _WeichProdDetailsState();
}

class _WeichProdDetailsState extends State<WeichProdDetails> {
  String tag = "";

  void cartUpdate(BuildContext context) {
    setState(() {
      tag = "description";
    });
    widget.onAdded();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: "list_${widget.product.name}$tag",
                    child: Padding(
                      padding: const EdgeInsets.all(70.0),
                      child: Image.asset(
                        widget.product.picture,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                    ),
                  ),
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.product.weight,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      const SizedBox(height: 80),
                      Spacer(),
                      Text(
                        "\€${widget.product.price}",
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.black,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                  Text(
                    "About the product :",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.product.description,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.blueGrey,
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () => cartUpdate(context),
                    style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      primary: Colors.blueGrey,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.white,
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
}
