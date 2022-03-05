import 'package:flutter/material.dart';
import 'package:shopping_app/analytics.dart';
import 'package:shopping_app/src/custom_widgets/image_card.dart';

import '../item_view.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({Key? key, required this.item}) : super(key: key);
  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Analytics.analytics.logEvent(name: 'item view', parameters: item);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemView(
                    item: item,
                  )),
        );
      },
      leading: CustomImageCard(
        imageUrl: item['url'],
        width: 65,
      ),
      title: Text(item['name']),
      subtitle: Text('€${item['price'].toString()}'),
    );
  }
}
