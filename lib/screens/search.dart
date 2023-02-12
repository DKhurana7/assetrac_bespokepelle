// ignore_for_file: avoid_print

import 'package:algolia/algolia.dart';
import 'package:assetrac_bespokepelle/screens/list.dart';
import 'package:assetrac_bespokepelle/screens/vendor.dart';
import 'package:assetrac_bespokepelle/services/algoliaservice.dart';
import 'package:flutter/material.dart';

import 'client.dart';

class AlgoliaAssetSearch extends StatefulWidget {
  const AlgoliaAssetSearch(
      {Key? key})
      : super(key: key);

  @override
  State<AlgoliaAssetSearch> createState() => _AlgoliaAssetSearchState();
}

class _AlgoliaAssetSearchState extends State<AlgoliaAssetSearch> {
  AlgoliaQuery? algoliaQuery;

  List<AlgoliaObjectSnapshot> _results = [];

  void algo(String? val) async {
    AlgoliaQuery query = algolia!.instance.index('asset').query(val!);

    AlgoliaQuerySnapshot snap = await query.getObjects();
    print('Hits Count: ${snap.nbHits}');
    print(snap.hits);
    _results = snap.hits;
    setState(() {});
  }

  late TextEditingController _searchController;
  Algolia? algolia;

  @override
  void initState() {
    algolia = Application.algolia;
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0XFF0A233E),
        title: const Text('Search Bar'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  algo(value);
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0XFF0A233E),
                    size: 25,
                  ),
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF0A233E)),
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _results.isEmpty
                ? const Center(
                    child: Text('No Assets Found'),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AssetDetails(
                                          _results[index].objectID)));
                            },
                            contentPadding: const EdgeInsets.all(10.0),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0XFF0A233E),
                              radius: 25.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        // image: NetworkImage(widget.imgName)
                                        image: _results[index]
                                                    .data
                                                    .containsKey('img') &&
                                                _results[index].data['img'] !=
                                                    ''
                                            ? NetworkImage(
                                                _results[index].data['img'])
                                            : const NetworkImage(
                                                'https://i1.wp.com/www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg?ssl=1'))),
                              ),
                            ),
                            title: Text(_results[index].data['name']),
                            // subtitle: Text(_results[index].data['id']),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                              ),
                            ),
                          );
                        }),
                  )
          ],
        ),
      ),
    );
  }
}


class AlgoliaClientSearch extends StatefulWidget {
  const AlgoliaClientSearch({Key? key}) : super(key: key);

  @override
  State<AlgoliaClientSearch> createState() => _AlgoliaClientSearchState();
}

class _AlgoliaClientSearchState extends State<AlgoliaClientSearch> {

  AlgoliaQuery? algoliaQuery;

  List<AlgoliaObjectSnapshot> _results = [];

  void algo(String? val) async {
    AlgoliaQuery query = algolia!.instance.index('client').query(val!);

    AlgoliaQuerySnapshot snap = await query.getObjects();
    print('Hits Count: ${snap.nbHits}');
    print(snap.hits);
    _results = snap.hits;
    setState(() {});
  }

  late TextEditingController _searchController;
  Algolia? algolia;

  @override
  void initState() {
    algolia = Application.algolia;
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0XFF0A233E),
        title: const Text('Search Bar'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  algo(value);
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0XFF0A233E),
                    size: 25,
                  ),
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF0A233E)),
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _results.isEmpty
                ? const Center(
              child: Text('No Clients Found'),
            )
                : Expanded(
              child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClientDetails(
                                    _results[index].objectID)));
                      },
                      contentPadding: const EdgeInsets.all(10.0),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0XFF0A233E),
                        radius: 25.0,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  // image: NetworkImage(widget.imgName)
                                  image: _results[index]
                                      .data
                                      .containsKey('img') &&
                                      _results[index].data['img'] !=
                                          ''
                                      ? NetworkImage(
                                      _results[index].data['img'])
                                      : const NetworkImage(
                                      'https://i1.wp.com/www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg?ssl=1'))),
                        ),
                      ),
                      title: Text(_results[index].data['name']),
                      subtitle: Text(_results[index].data['companyName']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}


class AlgoliaVendorSearch extends StatefulWidget {
  const AlgoliaVendorSearch({Key? key}) : super(key: key);

  @override
  State<AlgoliaVendorSearch> createState() => _AlgoliaVendorSearchState();
}

class _AlgoliaVendorSearchState extends State<AlgoliaVendorSearch> {
  AlgoliaQuery? algoliaQuery;

  List<AlgoliaObjectSnapshot> _results = [];

  void algo(String? val) async {
    AlgoliaQuery query = algolia!.instance.index('vendor').query(val!);

    AlgoliaQuerySnapshot snap = await query.getObjects();
    print('Hits Count: ${snap.nbHits}');
    print(snap.hits);
    _results = snap.hits;
    setState(() {});
  }

  late TextEditingController _searchController;
  Algolia? algolia;

  @override
  void initState() {
    algolia = Application.algolia;
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0XFF0A233E),
        title: const Text('Search Bar'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  algo(value);
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0XFF0A233E),
                    size: 25,
                  ),
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF0A233E)),
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _results.isEmpty
                ? const Center(
              child: Text('No Vendors Found'),
            )
                : Expanded(
              child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VendorDetails(
                                    _results[index].objectID)));
                      },
                      contentPadding: const EdgeInsets.all(10.0),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0XFF0A233E),
                        radius: 25.0,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  // image: NetworkImage(widget.imgName)
                                  image: _results[index]
                                      .data
                                      .containsKey('img') &&
                                      _results[index].data['img'] !=
                                          ''
                                      ? NetworkImage(
                                      _results[index].data['img'])
                                      : const NetworkImage(
                                      'https://i1.wp.com/www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg?ssl=1'))),
                        ),
                      ),
                      title: Text(_results[index].data['name']),
                      subtitle: Text(_results[index].data['companyName']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}


class AlgoliaStockSearch extends StatefulWidget {
  const AlgoliaStockSearch({Key? key}) : super(key: key);

  @override
  State<AlgoliaStockSearch> createState() => _AlgoliaStockSearchState();
}

class _AlgoliaStockSearchState extends State<AlgoliaStockSearch> {
  AlgoliaQuery? algoliaQuery;

  List<AlgoliaObjectSnapshot> _results = [];

  void algo(String? val) async {
    AlgoliaQuery query = algolia!.instance.index('stock').query(val!);

    AlgoliaQuerySnapshot snap = await query.getObjects();
    print('Hits Count: ${snap.nbHits}');
    print(snap.hits);
    _results = snap.hits;
    setState(() {});
  }

  late TextEditingController _searchController;
  Algolia? algolia;

  @override
  void initState() {
    algolia = Application.algolia;
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0XFF0A233E),
        title: const Text('Search Bar'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  algo(value);
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0XFF0A233E),
                    size: 25,
                  ),
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF0A233E)),
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _results.isEmpty
                ? const Center(
              child: Text('No Stock Found'),
            )
                : Expanded(
              child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      // onTap: () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => VendorDetails(
                      //               _results[index].objectID)));
                      // },
                      contentPadding: const EdgeInsets.all(10.0),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0XFF0A233E),
                        radius: 25.0,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  // image: NetworkImage(widget.imgName)
                                  image: _results[index]
                                      .data
                                      .containsKey('img') &&
                                      _results[index].data['img'] !=
                                          ''
                                      ? NetworkImage(
                                      _results[index].data['img'])
                                      : const NetworkImage(
                                      'https://i1.wp.com/www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg?ssl=1'))),
                        ),
                      ),
                      title: Text(_results[index].data['name']),
                      subtitle: Text(_results[index].data['quantity'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

