import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/cart_list_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _makingOrder = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$ ${cart.totalAmount.toStringAsFixed(2)}",
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  _makingOrder
                      ? SizedBox(width: 50, child: CircularProgressIndicator())
                      : FlatButton(
                          onPressed: (cart.totalAmount <= 0 || _makingOrder)
                              ? null
                              : () async {
                                  setState(() {
                                    _makingOrder = true;
                                  });
                                  try {
                                    await Provider.of<OrdersProvider>(context,
                                            listen: false)
                                        .addOrder(
                                      cart.items.values.toList(),
                                      cart.totalAmount,
                                    );
                                  } finally {
                                    setState(() {
                                      _makingOrder = false;
                                      cart.clearCart();
                                    });
                                  }
                                },
                          child: Text("Order Now"),
                          textColor: Theme.of(context).accentColor,
                        )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) {
                return CartListItem(
                  cart.items.values.toList()[i].id,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].title,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].price,
                );
              },
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
