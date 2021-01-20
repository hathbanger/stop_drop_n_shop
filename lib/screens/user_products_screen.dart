import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop_drop_n_shop/screens/edit_product_screen.dart';
import 'package:stop_drop_n_shop/widgets/store_drawer.dart';
import 'package:stop_drop_n_shop/widgets/user_product_item.dart';

import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: StoreDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) => UserProductItem(
              title: productsData.items[i].title,
              imageUrl: productsData.items[i].imageUrl,
              id: productsData.items[i].id,
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
