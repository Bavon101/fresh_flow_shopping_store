import 'package:flutter/material.dart';
import 'package:shopping_app/src/custom_widgets/image_card.dart';

class ItemView extends StatelessWidget {
  const ItemView({Key? key,required this.item}) : super(key: key);
  final Map<String, dynamic> item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']),
      ),
      body: Center(
        child: Column(
  
          children: [
            CustomImageCard(imageUrl: item['url'],height: _size(context).height *.45,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Cost €${item['price'].toString()}'),
            )
          ],
        ),
      ),
    );
  }

  Size _size(BuildContext context) => MediaQuery.of(context).size;
}
