import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:stop_drop_n_shop/providers/auth_provider.dart';
import 'package:stop_drop_n_shop/screens/auth_screen.dart';
import 'package:stop_drop_n_shop/screens/edit_product_screen.dart';
import 'package:stop_drop_n_shop/screens/orders_screen.dart';
import 'package:stop_drop_n_shop/screens/products_overview_screen.dart';
import 'package:stop_drop_n_shop/screens/user_products_screen.dart';

import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/products_provider.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(),
    ),
  );
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (ctx) => AuthProvider()),
  ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
    create: null,
    update: (ctx, auth, previousProducts) => ProductsProvider(
      auth.token,
      previousProducts == null ? [] : previousProducts.items,
      auth.userId,
    ),
  ),
  ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
    create: null,
    update: (ctx, auth, previousCart) => CartProvider(
        auth.token, previousCart == null ? {} : previousCart.items),
  ),
  ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
    create: null,
    update: (ctx, auth, previousOrders) => OrdersProvider(
        auth.token, previousOrders == null ? [] : previousOrders.orders),
  ),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (ctx, auth, _) => MaterialApp(
        title: 'StopDropNShop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
