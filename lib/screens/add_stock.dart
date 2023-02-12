import 'package:assetrac_bespokepelle/screens/stock.dart';
import 'package:assetrac_bespokepelle/services/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:assetrac_bespokepelle/services/textformfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

late var xData;
late bool showIcon;

TextEditingController nameController = TextEditingController();
TextEditingController categoryController = TextEditingController();
TextEditingController mrpController = TextEditingController();
TextEditingController quantityController = TextEditingController();
TextEditingController dopController = TextEditingController();
TextEditingController vendorController = TextEditingController();

class AddStock extends StatefulWidget {
  AddStock({Key? key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: const Color(0XFF0A233E),
          title: const Text('Add Stock'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('asset').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0XFF0A233E)));
              }
              if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                List<Map> items = documents
                    .map((e) =>
                {
                  'id': e.id,
                  'name': e['name'],
                  'category': e['category'],
                  'mrp': e['mrp'],
                })
                    .toList();

                Map<dynamic, dynamic>? selectedValue;

                return Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Which asset do you want to stock in?',
                            style: TextStyle(
                                color: Color(0XFF0A233E),
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 25),
                          DropdownSearch<Map<dynamic, dynamic>>(
                            items: items,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Assets',
                                labelStyle: const TextStyle(
                                  color: Color(0XFF0A233E),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Color(0XFF0A233E))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Color(0XFF0A233E))),
                              ),
                            ),
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            onChanged: (value) => xData = value,
                            itemAsString: (Map<dynamic, dynamic> val) =>
                            val["name"],
                            selectedItem: selectedValue,
                          ),
                          const SizedBox(height: 15),
                          MaterialButton(
                              color: const Color(0XFF0A233E),
                              onPressed: () {
                                setState(() {
                                  nameController.text = xData['name'];
                                  categoryController.text = xData['category'];
                                  mrpController.text = xData['mrp'];
                                });
                              },
                              child: const Text(
                                'Choose',
                                style: TextStyle(color: Colors.white),
                              )),
                          TextFormFieldCard(
                              controller: nameController,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validatorText: 'Enter Asset Name!',
                              labelText: 'Name',
                              prefixIcon: Icons.web_asset),
                          const SizedBox(height: 20),
                          TextFormFieldCard(
                              controller: categoryController,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validatorText: 'Enter Asset Category!',
                              labelText: 'Category',
                              prefixIcon: Icons.category),
                          const SizedBox(height: 20),
                          TextFormFieldCard(
                              controller: mrpController,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validatorText: 'Enter Asset MRP!',
                              labelText: 'MRP',
                              prefixIcon: FontAwesomeIcons.indianRupeeSign),
                          const SizedBox(height: 20),
                          TextFormFieldCard(
                              controller: quantityController,
                              enabled: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validatorText: 'Enter Asset Quantity!',
                              labelText: 'Quantity',
                              prefixIcon: Icons.production_quantity_limits),
                          const SizedBox(height: 20),
                          // TextFormFieldCard(
                          //     controller: dopController,
                          //     enabled: true,
                          //     keyboardType: TextInputType.datetime,
                          //     inputFormatters: <TextInputFormatter>[
                          //       FilteringTextInputFormatter.singleLineFormatter
                          //     ],
                          //     validatorText: 'Enter Asset Date of Purchase!',
                          //     labelText: 'Date',
                          //     prefixIcon: Icons.date_range),
                          // const SizedBox(height: 20),
                          // TextFormFieldCard(
                          //     controller: vendorController,
                          //     enabled: true,
                          //     keyboardType: TextInputType.text,
                          //     inputFormatters: <TextInputFormatter>[
                          //       FilteringTextInputFormatter.singleLineFormatter
                          //     ],
                          //     validatorText: 'Enter Asset Vendor Name!',
                          //     labelText: 'Vendor',
                          //     prefixIcon: Icons.person),
                          // const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('stock')
                                      .add({
                                    'name': nameController.text,
                                    'category': categoryController.text,
                                    'mrp': int.parse(mrpController.text.trim()),
                                    'quantity': int.parse(
                                        quantityController.text.trim()),
                                    // 'dop': dopController.text,
                                    // 'vendor': vendorController.text,
                                    'timestamp': DateTime.now(),
                                  }).then((response) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StockMaster()));
                                    Navigator.pop(context);
                                  });

                                  // final docRef = FirebaseFirestore.instance
                                  //     .collection('stock')
                                  //     .doc(items[0]['id']);
                                  // FirebaseFirestore.instance
                                  //     .runTransaction((transaction) async {
                                  //   final snapshot =
                                  //       await transaction.get(docRef);
                                  //   final newQuantity =
                                  //       snapshot.get('quantity') +
                                  //           int.parse(_quantityController.text);
                                  //   transaction.set(docRef, {
                                  //     'name': _nameController.text,
                                  //     'category': _categoryController.text,
                                  //     'mrp': _mrpController.text,
                                  //     'quantity': newQuantity
                                  //   });
                                  // }).then((value) {
                                  //   print('Doc Updated');
                                  //   Navigator.pop(context);
                                  // }, onError: (e) => print(e.toString()));

                                  // Map<String, dynamic> dataToSet = {
                                  //   'name': _nameController.text.trim(),
                                  //   'category': _categoryController.text.trim(),
                                  //   'mrp': _mrpController.text.trim(),
                                  //   'quantity': FieldValue.increment(int.parse(
                                  //       _quantityController.text.trim())),
                                  //   'timestamp': DateTime.now(),
                                  // };
                                  //
                                  // _reference.update(dataToSet);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => StockMaster()));
                                  //
                                  // setState(() {
                                  //   nameController.clear();
                                  //   categoryController.clear();
                                  //   mrpController.clear();
                                  //   quantityController.clear();
                                  //   dopController.clear();
                                  //   vendorController.clear();
                                  // });
                                },
                                color: const Color(0XFF0A233E),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 40),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  nameController.clear();
                                  categoryController.clear();
                                  mrpController.clear();
                                  quantityController.clear();
                                  dopController.clear();
                                  vendorController.clear();
                                },
                                color: const Color(0XFF0A233E),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
                  ),
                );
              }
              return const Center(
                  child: CircularProgressIndicator(color: Color(0XFF0A233E)));
            }));
  }
}

class EditStock extends StatefulWidget {
  final Map<String, dynamic> assetItem;

  const EditStock(this.assetItem, {Key? key}) : super(key: key);

  @override
  State<EditStock> createState() => _EditStockState();
}

class _EditStockState extends State<EditStock> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _mrpController;
  late TextEditingController _quantityController;
  late DocumentReference _reference;
  final _formKey = GlobalKey<FormState>();

  // late String itemId;

  @override
  initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.assetItem['name']);
    _categoryController =
        TextEditingController(text: widget.assetItem['category']);
    _mrpController =
        TextEditingController(text: widget.assetItem['mrp'].toString());
    _quantityController = TextEditingController();
    // _quantityController =
    //     TextEditingController(text: widget.assetItem['quantity'].toString());
    _reference = FirebaseFirestore.instance
        .collection('stock')
        .doc(widget.assetItem['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: const Color(0XFF0A233E),
          title: const Text('Add Stock'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('stock').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0XFF0A233E)));
              }
              if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                List<Map> items = documents
                    .map((e) =>
                {
                  'id': e.id,
                  'name': e['name'],
                  'category': e['category'],
                  'mrp': e['mrp'],
                })
                    .toList();

                Map<dynamic, dynamic>? selectedValue;

                return Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Which asset do you want to stock in?',
                            style: TextStyle(
                                color: Color(0XFF0A233E),
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 25),
                          DropdownSearch<Map<dynamic, dynamic>>(
                            items: items,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Assets',
                                labelStyle: const TextStyle(
                                  color: Color(0XFF0A233E),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Color(0XFF0A233E))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Color(0XFF0A233E))),
                              ),
                            ),
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            onChanged: (value) => xData = value,
                            itemAsString: (Map<dynamic, dynamic> val) =>
                            val["name"],
                            selectedItem: selectedValue,
                          ),
                          const SizedBox(height: 15),
                          MaterialButton(
                              color: const Color(0XFF0A233E),
                              onPressed: () {
                                setState(() {
                                  _nameController.text = xData['name'];
                                  _categoryController.text = xData['category'];
                                  _mrpController.text = xData['mrp'].toString();
                                });
                              },
                              child: const Text(
                                'Choose',
                                style: TextStyle(color: Colors.white),
                              )),
                          TextFormFieldCard(
                              controller: _nameController,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validatorText: 'Enter Asset Name!',
                              labelText: 'Name',
                              prefixIcon: Icons.web_asset),
                          const SizedBox(height: 20),
                          TextFormFieldCard(
                              controller: _categoryController,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validatorText: 'Enter Asset Category!',
                              labelText: 'Category',
                              prefixIcon: Icons.category),
                          const SizedBox(height: 20),
                          TextFormFieldCard(
                              controller: _mrpController,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validatorText: 'Enter Asset MRP!',
                              labelText: 'MRP',
                              prefixIcon: FontAwesomeIcons.indianRupeeSign),
                          const SizedBox(height: 20),
                          TextFormFieldCard(
                              controller: _quantityController,
                              enabled: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validatorText: 'Enter Asset Quantity!',
                              labelText: 'Quantity',
                              prefixIcon: Icons.production_quantity_limits),
                          const SizedBox(height: 20),
                          // TextFormFieldCard(
                          //     controller: dopController,
                          //     enabled: true,
                          //     keyboardType: TextInputType.datetime,
                          //     inputFormatters: <TextInputFormatter>[
                          //       FilteringTextInputFormatter.singleLineFormatter
                          //     ],
                          //     validatorText: 'Enter Asset Date of Purchase!',
                          //     labelText: 'Date',
                          //     prefixIcon: Icons.date_range),
                          // const SizedBox(height: 20),
                          // TextFormFieldCard(
                          //     controller: vendorController,
                          //     enabled: true,
                          //     keyboardType: TextInputType.text,
                          //     inputFormatters: <TextInputFormatter>[
                          //       FilteringTextInputFormatter.singleLineFormatter
                          //     ],
                          //     validatorText: 'Enter Asset Vendor Name!',
                          //     labelText: 'Vendor',
                          //     prefixIcon: Icons.person),
                          // const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('transaction')
                                      .add({
                                    'name': _nameController.text,
                                    'category': _categoryController.text,
                                    'mrp': _mrpController.text,
                                    'quantity':
                                    int.parse(_quantityController.text),
                                    'remarks': null,
                                    'img': null,
                                    // 'dop': dopController.text,
                                    // 'vendor': vendorController.text,
                                    'timestamp': DateTime.now(),
                                  });


                                  FirebaseFirestore.instance
                                      .runTransaction((transaction) async {
                                    final snapshot =
                                    await transaction.get(_reference);
                                    final newQuantity =
                                        snapshot.get('quantity') +
                                            int.parse(_quantityController.text);
                                    transaction.update(_reference, {
                                      // 'name': _nameController.text,
                                      // 'category': _categoryController.text,
                                      // 'mrp': _mrpController.text,
                                      'quantity': newQuantity
                                    });
                                  }).then((value) {
                                    Navigator.pop(context);
                                  }, onError: (e) =>
                                      Utils.showSnackBar(e.toString()));

                                  setState(() {
                                    nameController.clear();
                                    categoryController.clear();
                                    mrpController.clear();
                                    quantityController.clear();
                                    dopController.clear();
                                    vendorController.clear();
                                  });
                                },
                                color: const Color(0XFF0A233E),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 40),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  nameController.clear();
                                  categoryController.clear();
                                  mrpController.clear();
                                  quantityController.clear();
                                  dopController.clear();
                                  vendorController.clear();
                                },
                                color: const Color(0XFF0A233E),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                    ),
                  ),
                );
              }
              return const Center(
                  child: CircularProgressIndicator(color: Color(0XFF0A233E)));
            }));
  }
}
