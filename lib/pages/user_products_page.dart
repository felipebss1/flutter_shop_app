import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shop_app/pages/edit_product_page.dart';
import 'package:flutter_shop_app/provider/products_provider.dart';
import 'package:flutter_shop_app/widgets/user_product_item.dart';

class UserProductsPage extends StatelessWidget {
  const UserProductsPage({super.key});

  static const routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_, index) => UserProductItem(
            title: productsData.items[index].title,
            imageURL: productsData.items[index].imageURL,
          ),
          itemCount: productsData.items.length,
        ),
      ),
    );
  }
}
