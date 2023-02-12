import 'package:assetrac_bespokepelle/screens/add_stock.dart';
import 'package:assetrac_bespokepelle/screens/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class StockMaster extends StatefulWidget {
  StockMaster({Key? key}) : super(key: key) {
    stream = _reference.orderBy('quantity').snapshots();
  }

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('stock');
  late final Stream<QuerySnapshot> stream;

  @override
  State<StockMaster> createState() => _StockMasterState();
}

class _StockMasterState extends State<StockMaster> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> items;
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0XFF0A233E),
          title: const Text('Stock Master')),
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Some Error Occurred"));
            }
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;

              List<Map<String, dynamic>> items = documents
                  .map((e) => {
                        'id': e.id,
                        'name': e['name'],
                        'category': e['category'],
                        'mrp': e['mrp'],
                        'quantity': e['quantity'],
                        // 'dop': e['dop'],
                        // 'vendor': e['vendor'],
                      })
                  .toList();

              return ListView.builder(
                  padding: const EdgeInsets.all(5.0),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> thisItem = items[index];
                    return Column(
                      children: [
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Card(
                            color: Colors.white,
                            child: SizedBox(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        'ID: ${thisItem['id'].toString().substring(0, 3)}'),
                                    Text('Name: ${thisItem['name']}'),
                                    Text('Category: ${thisItem['category']}'),
                                    Text('Quantity: ${thisItem['quantity']}'),
                                    // Text('Date: ${thisItem['dop']}'),
                                    // Text('Vendor: ${thisItem['vendor']}'),
                                    Text('Price: ${thisItem['mrp']}'),
                                    MaterialButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditStock(thisItem))),
                                        color: const Color(0XFF0A233E),
                                        child: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21),) )
                                  ],
                                )),
                          ),
                        )
                      ],
                    );
                  });
            }
            return const Center(
                child: CircularProgressIndicator(color: Color(0XFF0A233E)));
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0XFF0A233E),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddStock()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class StockStatus extends StatefulWidget {
  StockStatus({Key? key}) : super(key: key) {
    stream = _reference.orderBy('quantity').snapshots();
  }

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('stock');
  late final Stream<QuerySnapshot> stream;

  @override
  State<StockStatus> createState() => _StockStatusState();
}

class _StockStatusState extends State<StockStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AlgoliaStockSearch()));
              },
            )
          ],
          centerTitle: true,
          backgroundColor: const Color(0XFF0A233E),
          title: const Text('Stock Status')),
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Some Error Occurred"));
            }
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;

              List<Map> items = documents
                  .map((e) => {
                        'id': e.id,
                        'name': e['name'],
                        'category': e['category'],
                        'mrp': e['mrp'],
                        'quantity': e['quantity'],
                        // 'dop': e['dop'],
                        // 'vendor': e['vendor'],
                      })
                  .toList();

              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = items[index];
                    return Column(
                      children: [
                        const SizedBox(height: 2),
                        ListTile(
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -3),
                          tileColor: Colors.white,
                          contentPadding: const EdgeInsets.all(10.0),
                          title: Text(thisItem['name']),
                          subtitle: Text(thisItem['quantity'].toString()),
                        ),
                        MaterialButton(
                          onPressed: () {
                            final docRef = FirebaseFirestore.instance
                                .collection('stock')
                                .doc(items[index]['id']);
                            FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              final snapshot = await transaction.get(docRef);
                              final newQuantity = snapshot.get('quantity') + 1;
                              transaction
                                  .update(docRef, {'quantity': newQuantity});
                            }).then((value) => print('Doc Updated'),
                                onError: (e) => print('Error!'));
                          },
                          child: const Text('Transaction'),
                        )
                      ],
                    );
                  });
            }
            return const Center(
                child: CircularProgressIndicator(color: Color(0XFF0A233E)));
          }),
    );
  }
}
