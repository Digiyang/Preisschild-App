import 'package:flutter/material.dart';
import 'package:flutter_app/Bakerys/Weichardt/components/weichProductDetails.dart';
import 'package:flutter_app/Bakerys/Weichardt/components/weichProvider.dart';
import 'package:flutter_app/Bakerys/Weichardt/screens/shopInventoryScrenn.dart';
import 'package:flutter_app/widgets/staggered_dual_view.dart';

class WeichList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = WeichProvider.of(context).bloc;
    return Container(
      color: Colors.blueGrey,
      padding: const EdgeInsets.only(top: cartHeight),
      child: StaggeredDualView(
        aspectRatio: 0.7,
        offsetPercent: 0.15,
        spacing: 15,
        itemBuilder: (context, index) {
          final product = bloc.inventory[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 900),
                  pageBuilder: (context, animation, __) {
                    return FadeTransition(
                      opacity: animation,
                      child: WeichProdDetails(
                          product: product,
                          onAdded: () {
                            bloc.addProduct(product);
                          }),
                    );
                  },
                ),
              );
            },
            child: Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              elevation: 10,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Hero(
                        tag: "list_${product.name}",
                        child: Image.asset(
                          product.picture,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      '\€${product.price}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      product.weight,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: bloc.inventory.length,
      ),
    );
    /*return ListView.builder(
      padding: const EdgeInsets.only(top: cartHeight),
      itemCount: bloc.inventory.length,
      itemBuilder: (context, index) {
        return Container(
          height: 100,
          width: 100,
          color: Colors.primaries[index % Colors.primaries.length],
        );
      },
    );*/
  }
}
