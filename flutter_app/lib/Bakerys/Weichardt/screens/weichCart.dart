import 'package:flutter/material.dart';
import 'package:flutter_app/Bakerys/Weichardt/components/weichProvider.dart';

class WeichCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = WeichProvider.of(context).bloc;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Cart",
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: bloc.cart.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  bloc.cart[index].product.picture,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                bloc.cart[index].number.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                              const SizedBox(width: 10),
                              Text("x",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0)),
                              const SizedBox(width: 10),
                              Text(bloc.cart[index].product.name,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0)),
                              Spacer(),
                              Text(
                                  "\€${(bloc.cart[index].product.price * bloc.cart[index].number).toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0)),
                              const SizedBox(width: 10),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    bloc.throwProduct(bloc.cart[index]);
                                  })
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              children: [
                Text(
                  "Total:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  "\€${bloc.sumPrice().toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => null,
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                primary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Order",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }
}
