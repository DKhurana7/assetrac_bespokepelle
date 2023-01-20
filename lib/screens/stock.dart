import 'package:assetrac_bespokepelle/screens/add_stock.dart';
import 'package:assetrac_bespokepelle/screens/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class StockMaster extends StatefulWidget {
  StockMaster({Key? key}) : super(key: key) {
    stream = _reference.orderBy('code').snapshots();
  }

  final CollectionReference _reference = FirebaseFirestore.instance.collection('stock');
  late final Stream<QuerySnapshot> stream;

  @override
  State<StockMaster> createState() => _StockMasterState();
}

class _StockMasterState extends State<StockMaster> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.search),
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => const AlgoliaSearch()));
        //     },
        //   )
        // ],
          centerTitle: true,
          backgroundColor: const Color(0xFF0a233e),
          title: const Text('Stock Master')),
      body: StreamBuilder<QuerySnapshot>(
          stream: widget.stream,
          builder:
              (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Some Error Occurred"));
            }
            if(snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;

              List<Map> items = documents.map((e) => {

                'id': e.id,
                'code': e['code'],
                'name': e['name'],
                'category': e['category'],
                'mrp': e['mrp'],
                'quantity': e['quantity'],
                'dop': e['dop'],
                'vendor': e['vendor'],

              }).toList();

              return ListView.builder(
                  padding: const EdgeInsets.all(5.0),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = items[index];
                    return Column(
                      children: [
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            color: Colors.white,
                            child: SizedBox(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('ID: ${thisItem['id'].toString().substring(0,10)}'),
                                    Text('Name: ${thisItem['name']}'),
                                    Text('Category: ${thisItem['category']}'),
                                    Text('Quantity: ${thisItem['quantity']}'),
                                    Text('Date: ${thisItem['dop']}'),
                                    Text('Vendor: ${thisItem['vendor']}'),
                                    Text('Price: ${thisItem['mrp']}'),
                                  ],
                                )
                            ),
                          ),
                        )
                      ],
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0a233e),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddStock()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}



class StockStatus extends StatefulWidget {
  StockStatus({Key? key}) : super(key: key) {
    stream = _reference.orderBy('code').snapshots();
  }

  final CollectionReference _reference = FirebaseFirestore.instance.collection('stock');
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
                          builder: (context) => const AlgoliaSearch(indexName: 'stock', imgName: 'https://i1.wp.com/www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg?ssl=1',)));
                },
              )
            ],
            centerTitle: true,
            backgroundColor: const Color(0xFF0a233e),
            title: const Text('Stock Status')),
        body: StreamBuilder<QuerySnapshot>(
            stream: widget.stream,
            builder:
                (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("Some Error Occurred"));
              }
              if(snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                List<Map> items = documents.map((e) => {

                  'id': e.id,
                  'code': e['code'],
                  'name': e['name'],
                  'category': e['category'],
                  'mrp': e['mrp'],
                  'quantity': e['quantity'],
                  'dop': e['dop'],
                  'vendor': e['vendor'],


                }).toList();

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
                            // onTap: () {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (BuildContext context) =>
                            //               AssetDetails(thisItem['id'])));
                            // },
                            contentPadding: const EdgeInsets.all(10.0),
                            // leading: CircleAvatar(
                            //   backgroundColor: const Color(0xFF0a233e),
                            //   radius: 25.0,
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //         shape: BoxShape.rectangle,
                            //         image: DecorationImage(
                            //             fit: BoxFit.cover,
                            //             image: NetworkImage(thisItem['image'])
                            //         )),
                            //   ),
                            // ),
                            title: Text(thisItem['name']),
                            subtitle: Text(thisItem['quantity']),
                          ),
                        ],
                      );
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: const Color(0xFF0a233e),
        //   onPressed: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => const AddAssets()));
        //   },
        //   child: const Icon(Icons.add),
        // ),
      );
  }
}

