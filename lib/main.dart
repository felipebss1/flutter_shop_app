import 'package:flutter/material.dart';
import 'package:flutter_shop_app/pages/orders_page.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shop_app/pages/cart_screen.dart';
import 'package:flutter_shop_app/provider/orders.dart';
import 'package:flutter_shop_app/pages/product_detail_page.dart';
import 'package:flutter_shop_app/pages/products_overview_page.dart';
import 'package:flutter_shop_app/provider/cart.dart';
import 'package:flutter_shop_app/provider/products_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        home: const ProductsOverviewPage(),
        routes: {
          ProductDetailPage.routeName: (context) => const ProductDetailPage(),
          CartPage.routeName: (context) => const CartPage(),
          OrdersPage.routeName: (context) => const OrdersPage(),
        },
      ),
    );
  }
}
