// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_shop_app/pages/edit_product_page.dart';
import 'package:flutter_shop_app/provider/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String? id;
  final String title;
  final String imageURL;
  const UserProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final snackBarMessage = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductPage.routeName, arguments: id);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id!);
                } catch (e) {
                  snackBarMessage.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Failed to delete',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
