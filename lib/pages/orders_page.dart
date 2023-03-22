import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shop_app/provider/orders.dart' show Orders;
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/order_item.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) => OrderItem(
          order: orderData.orders[index],
        ),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
