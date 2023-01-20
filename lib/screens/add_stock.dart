import 'package:assetrac_bespokepelle/screens/stock.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:assetrac_bespokepelle/services/textformfield.dart';

late var xData;
late bool showIcon;

TextEditingController codeController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController categoryController = TextEditingController();
TextEditingController mrpController = TextEditingController();
TextEditingController quantityController = TextEditingController();
TextEditingController dopController = TextEditingController();
TextEditingController vendorController = TextEditingController();

class AddStock extends StatefulWidget {
  const AddStock({Key? key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

final _formKey = GlobalKey<FormState>();

class _AddStockState extends State<AddStock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A233E),
          title: const Text('Add Stock'),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('asset').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                QuerySnapshot querySnapshot = snapshot.data;
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                List<Map> items = documents
                    .map((e) => {
                          'id': e.id,
                          'code': e['code'],
                          'name': e['name'],
                          'category': e['category'],
                          'mrp': e['mrp'],
                          'remarks': e['remarks'],
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
                            'What asset do you want to stock in?',
                            style: TextStyle(
                                color: Color(0xFF0A233E),
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 25),
                          DropdownSearch<Map<dynamic, dynamic>>(
                            items: items,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Assets',
                                labelStyle: const TextStyle(
                                  color: Color(0xFF0a233e),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Color(0xFF0a233e))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: const BorderSide(
                                        width: 2.0, color: Color(0xFF0a233e))),
                                // suffixIcon: IconButton(
                                //         icon: Icon(Icons.check),
                                //         onPressed: () {
                                //           setState(() {
                                //             codeController.text = xData['code'];
                                //             nameController.text = xData['name'];
                                //             categoryController.text = xData['category'];
                                //           });
                                //         },
                                //       )
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
                              color: const Color(0xFF0A233E),
                              onPressed: () {
                                setState(() {
                                  codeController.text =
                                      xData['id'].toString().substring(0,10);
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
                              controller: codeController,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validatorText: 'Enter Asset Code!',
                              labelText: 'Code',
                              prefixIcon: Icons.numbers),
                          const SizedBox(height: 20),
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
                              prefixIcon: Icons.attach_money),
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
                          TextFormFieldCard(
                              controller: dopController,
                              enabled: true,
                              keyboardType: TextInputType.datetime,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validatorText: 'Enter Asset Date of Purchase!',
                              labelText: 'Date',
                              prefixIcon: Icons.date_range),
                          const SizedBox(height: 20),
                          TextFormFieldCard(
                              controller: vendorController,
                              enabled: true,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              validatorText: 'Enter Asset Vendor Name!',
                              labelText: 'Vendor',
                              prefixIcon: Icons.person),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      quantityController.text.isNotEmpty &&
                                      dopController.text.isNotEmpty &&
                                      vendorController.text.isNotEmpty) {
                                    FirebaseFirestore.instance
                                        .collection('stock')
                                        .add({
                                      'code': codeController.text,
                                      'name': nameController.text,
                                      'category': categoryController.text,
                                      'mrp': mrpController.text,
                                      'quantity': quantityController.text,
                                      'dop': dopController.text,
                                      'vendor': vendorController.text,
                                      'img': '',
                                      'timestamp': DateTime.now(),
                                    }).then((response) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StockMaster()));
                                    });
                                    setState(() {
                                      codeController.clear();
                                      nameController.clear();
                                      categoryController.clear();
                                      mrpController.clear();
                                      quantityController.clear();
                                      dopController.clear();
                                      vendorController.clear();
                                    });
                                  }
                                },
                                color: const Color(0xFF0A233E),
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
                                  codeController.clear();
                                  nameController.clear();
                                  categoryController.clear();
                                  mrpController.clear();
                                  quantityController.clear();
                                  dopController.clear();
                                  vendorController.clear();
                                },
                                color: const Color(0xFF0a233e),
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
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
