import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/pages/item/custom_widgets/item_card.dart';

import '../../analytics.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  Future<void> _logEvent() async {
    await Analytics.analytics.logEvent(
        name: 'page view',
        parameters: {'user_email': FirebaseAuth.instance.currentUser?.email});
  }

  @override
  void initState() {
    super.initState();
    //call the _logEvent here to log that the user visited this product screen
    _logEvent().catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart View'),
        actions: [
          IconButton(
            tooltip: 'logout',
              onPressed: () async {
                // log the logout event
                await Analytics.analytics.logEvent(name: 'logout', parameters: {
                  'user_email': FirebaseAuth.instance.currentUser?.email
                });
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      // user stream to list-check the items
      // by default firebase_cloud will reference the last fetched data. making it work offline
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('items').snapshots(),
          builder: (context, snapshot) {
            // check if there is data and only the should we proceed
            if (snapshot.hasData) {
              List<DocumentSnapshot> _items = snapshot.data!.docs;
              // check if the items list is empty
              if (_items.isEmpty) {
                return const _emptyCartInfo();
              }
              return Scrollbar(
                child: ListView.separated(
                    separatorBuilder: (context, i) => const Divider(),
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      Map<String, dynamic> item =
                          _items[i].data() as Map<String, dynamic>;
                      // return the item card
                      return ItemCard(item: item);
                    }),
              );
            } else if (snapshot.hasError) {
              return _onError();
            }
            return _loadingIndicator();
          }),
    );
  }

  Center _onError() {
    return Center(
              child: Column(
                children:const [
                  Icon(Icons.error),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Something went wrong, please try again later'),
                  )
                ],
              ),
            );
  }

  Center _loadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _emptyCartInfo extends StatelessWidget {
  const _emptyCartInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_cart),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Your cart is empty'),
          )
        ],
      ),
    );
  }
}
