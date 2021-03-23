import 'package:flutter/material.dart';
import 'package:flutter_app/Bakerys/Weichardt/blocs/weichBloc.dart';
import 'package:flutter_app/Bakerys/Weichardt/components/weichProvider.dart';
import 'package:flutter_app/Bakerys/Weichardt/screens/weichCart.dart';
import 'package:flutter_app/Bakerys/Weichardt/screens/weichList.dart';
import 'package:flutter_app/screens/bar.dart';

const cartHeight = 100.0;

class ShopInventoryHome extends StatefulWidget {
  @override
  _ShopInventoryHomeState createState() => _ShopInventoryHomeState();
}

class _ShopInventoryHomeState extends State<ShopInventoryHome> {
  final bloc = WeichBloc();

  void onVert(DragUpdateDetails details) {
    if (details.primaryDelta < -7) {
      bloc.toCart();
    } else if (details.primaryDelta > 12) {
      bloc.toNormal();
    }
  }

  double WhitePanel(ShopState state, Size size) {
    if (state == ShopState.normal) {
      return -cartHeight +
          kToolbarHeight -
          MediaQuery.of(context).padding.bottom;
    } else if (state == ShopState.cart) {
      return -(size.height - kToolbarHeight * 4 - cartHeight / 2);
    }
    return 0.0;
  }

  double BlackPanel(ShopState state, Size size) {
    if (state == ShopState.normal) {
      return size.height - cartHeight;
    } else if (state == ShopState.cart) {
      return cartHeight / 1;
    }
    return 0.0;
  }

  double appBarPanel(ShopState state) {
    if (state == ShopState.normal) {
      return 0.0;
    } else if (state == ShopState.cart) {
      return -cartHeight;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WeichProvider(
      bloc: bloc,
      child: AnimatedBuilder(
        animation: bloc,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: Colors.blueGrey,
            body: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  left: 0,
                  right: 0,
                  top: 0,
                  height: size.height - kToolbarHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: WeichList(),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  curve: Curves.decelerate,
                  duration: Duration(milliseconds: 500),
                  left: 0,
                  right: 0,
                  top: BlackPanel(bloc.state, size),
                  height: size.height - kToolbarHeight,
                  child: GestureDetector(
                    onVerticalDragUpdate: onVert,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.blueGrey[400]),
                      //color: Colors.blueGrey[400],
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 500),
                              child: SizedBox(
                                  height: kToolbarHeight,
                                  child: bloc.state == ShopState.normal
                                      ? Row(
                                          children: [
                                            Text(
                                              "Cart",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: List.generate(
                                                    bloc.cart.length,
                                                    (index) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Stack(
                                                          children: [
                                                            Hero(
                                                              tag:
                                                                  "list_${bloc.cart[index].product.name}description",
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                  bloc
                                                                      .cart[
                                                                          index]
                                                                      .product
                                                                      .picture,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              right: 0,
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 9,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                child: Text(
                                                                  bloc
                                                                      .cart[
                                                                          index]
                                                                      .number
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            CircleAvatar(
                                              foregroundColor: Colors.black,
                                              backgroundColor: Colors.white,
                                              child: Text(
                                                  bloc.sumItems().toString()),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink()),
                            ),
                          ),
                          Expanded(child: WeichCart()),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  curve: Curves.decelerate,
                  duration: Duration(milliseconds: 500),
                  left: 0,
                  right: 0,
                  top: appBarPanel(bloc.state),
                  child: appBar(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
