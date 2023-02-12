import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../services/textformfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/utils.dart';

class AssetSalesData {
  AssetSalesData(this.asset, this.sales);
  final String asset;
  final int sales;
}

class AssetQuantityData {
  AssetQuantityData(this.asset, this.quantity);
  final String asset;
  final int quantity;
}

var xData;


TextEditingController nameController = TextEditingController();
TextEditingController categoryController = TextEditingController();
TextEditingController mrpController = TextEditingController();
TextEditingController quantityController = TextEditingController();
TextEditingController dosController = TextEditingController();
TextEditingController clientController = TextEditingController();
TextEditingController discountController = TextEditingController();

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, color: const Color(0XFF0A233E));
    super.initState();
  }

  DateTimeRange dateRange = DateTimeRange(
      start: DateTime(DateTime.now().year, 01, 01),
      end: DateTime(DateTime.now().year, 12, 30));

  final _scaffoldKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0XFF0A233E),
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: pickDateRange,
                ),
                // Positioned(
                //   top: 12.0,
                //   right: 10.0,
                //   width: 10.0,
                //   height: 10.0,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: Colors.red,
                //     ),
                //   ),
                // ),
              ],
            ),
            const Expanded(
              child: Center(child: Text('Sales')),
            ),
            const SizedBox(width: 50),
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      endDrawer: const Drawer(
        child: Filters(),
      ),
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blue[50],
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sales')
                  .where('timestamp', isGreaterThanOrEqualTo: start)
                  .where('timestamp', isLessThanOrEqualTo: end)
                  .where('value', isEqualTo: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E)));
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
                            'discount': e['discount']
                          })
                      .toList();

                  return SfCartesianChart(
                    title: ChartTitle(
                        text:
                            'Bespoke Pelle Sales: \n ${start.day}/${start.month}/${start.year} To ${end.day}/${end.month}/${end.year} \n (In INR)'),
                    // legend: Legend(
                    //     isVisible: true,
                    //     overflowMode: LegendItemOverflowMode.wrap),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries>[
                      BarSeries<AssetSalesData, String>(
                          name: 'Sales',
                          color: const Color(0XFF0A233E),
                          dataSource: [
                            for (int i = 0; i < items.length; i++) ...[
                              AssetSalesData(
                                '${items[i]['quantity']} - ${items[i]['name']}',
                                (int.parse(items[i]['mrp']) *
                                    int.parse(items[i]['quantity']) *
                                    (100 - int.parse(items[i]['discount'])) ~/
                                    100),

                                // ((int.parse(items[i]['mrp']) *
                                //         int.parse(items[i]['quantity'])) -
                                //     (int.parse(items[i]['discount']) ~/
                                //             (100)) *
                                //         ((int.parse(items[i]['mrp']) *
                                //             int.parse(items[i]['quantity'])))),
                              )
                            ],
                          ],
                          xValueMapper: (AssetSalesData data, _) => data.asset,
                          yValueMapper: (AssetSalesData data, _) => data.sales,
                          dataLabelSettings: const DataLabelSettings(
                              isVisible: true, color: Color(0XFF0A233E)),
                          enableTooltip: true),
                      // BarSeries<AssetQuantityData, String>(
                      //     dataSource: [
                      //       for (int i = 0; i < items.length; i++) ...[
                      //       AssetQuantityData(
                      //           items[i]['name'],
                      //           int.parse(items[i]['quantity'])
                      //
                      //         // ((int.parse(items[i]['mrp']) *
                      //         //         int.parse(items[i]['quantity'])) -
                      //         //     (int.parse(items[i]['discount']) ~/
                      //         //             (100)) *
                      //         //         ((int.parse(items[i]['mrp']) *
                      //         //             int.parse(items[i]['quantity'])))),
                      //
                      //       )
                      //     ],
                      //     ],
                      //     xValueMapper: (AssetQuantityData data, _) => data.asset,
                      //     yValueMapper: (AssetQuantityData data, _) => data.quantity)
                    ],
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        numberFormat: NumberFormat.simpleCurrency(
                            decimalDigits: 0, name: 'INR'),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E)));
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => MakeSale()));
        },
        backgroundColor: const Color(0XFF0A233E),
        child: const Text('₹', style: TextStyle(fontSize: 25)),
      ),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0XFF0A233E),
              onPrimary: Colors.white,
              onSurface: Color(0XFF0A233E),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );

    if (newDateRange == null) return;

    setState(() {
      dateRange = newDateRange;
    });
  }
}

class Filters extends StatefulWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  // final allFilters = CheckBoxState(title: 'Select All', value: true);
  //
  // final filters = [
  //   CheckBoxState(title: 'Filter1', value: true),
  //   CheckBoxState(title: 'Filter2', value: true),
  //   CheckBoxState(title: 'Filter3', value: true),
  //   CheckBoxState(title: 'Filter4', value: true)
  // ];
  //
  // final filterTypes = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('sales').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E)));
          }

          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data.docs[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                return Column(
                  children: [
                    CheckboxListTile(
                        activeColor: const Color(0XFF0A233E),
                        title: Text(data['name']),
                        value: data['value'],
                        onChanged: (bool? value) {
                          FirebaseFirestore.instance
                              .collection('sales')
                              .doc(document.id)
                              .update({'value': value!});
                        }),
                  ],
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E)));
        });
  }

// Widget buildSingleCheckBox(CheckBoxState checkbox) => CheckboxListTile(
//     controlAffinity: ListTileControlAffinity.leading,
//     activeColor: const Color(0XFF0A233E),
//     value: checkbox.value,
//     title: Text(checkbox.title, style: const TextStyle(fontSize: 15)),
//     onChanged: (value) => setState(() {
//           checkbox.value = value!;
//           allFilters.value = filters.every((filter) => filter.value);
//         }));
//
// Widget buildGroupCheckBox(CheckBoxState checkbox) => CheckboxListTile(
//       controlAffinity: ListTileControlAffinity.leading,
//       activeColor: const Color(0XFF0A233E),
//       value: checkbox.value,
//       title: Text(checkbox.title, style: const TextStyle(fontSize: 15)),
//       onChanged: toggleGroupCheckbox,
//     );
//
// void toggleGroupCheckbox(bool? value) {
//   if (value == null) return;
//
//   setState(() {
//     allFilters.value = value;
//     filters.forEach((filter) => filter.value = value);
//   });
// }
}

// class CheckBoxState {
//   final String title;
//   bool value;
//
//   CheckBoxState({required this.title, required this.value});
// }

class MakeSale extends StatefulWidget {
  Map<String, dynamic> assetItem;
  MakeSale(this.assetItem, {Key? key}) : super(key: key);

  @override
  State<MakeSale> createState() => _MakeSaleState();
}

final _formKey = GlobalKey<FormState>();

class _MakeSaleState extends State<MakeSale> {

  late DocumentReference _reference;

  @override
  initState() {
    super.initState();
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
        title: const Text('Make a Sale'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('asset').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E)));
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
                          'Which asset did you sell?',
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
                            validatorText: 'Enter Quantity!',
                            labelText: 'Quantity',
                            prefixIcon: Icons.production_quantity_limits),
                        const SizedBox(height: 20),
                        TextFormFieldCard(
                            controller: discountController,
                            enabled: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validatorText: 'Enter Discount!',
                            labelText: 'Discount',
                            prefixIcon: Icons.percent),
                        const SizedBox(height: 20),
                        TextFormFieldCard(
                            controller: dosController,
                            enabled: true,
                            keyboardType: TextInputType.datetime,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.singleLineFormatter
                            ],
                            validatorText: 'Enter Date of Sale!',
                            labelText: 'Date',
                            prefixIcon: Icons.date_range),
                        const SizedBox(height: 20),
                        TextFormFieldCard(
                            controller: clientController,
                            enabled: true,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.singleLineFormatter
                            ],
                            validatorText: 'Enter Client!',
                            labelText: 'Client',
                            prefixIcon: Icons.person),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    quantityController.text.isNotEmpty &&
                                    discountController.text.isNotEmpty &&
                                    dosController.text.isNotEmpty &&
                                    clientController.text.isNotEmpty) {
                                  FirebaseFirestore.instance
                                      .collection('sales')
                                      .add({
                                    'name': nameController.text,
                                    'category': categoryController.text,
                                    'mrp': mrpController.text,
                                    'quantity': quantityController.text,
                                    'discount': discountController.text,
                                    'dos': dosController.text,
                                    'client': clientController.text,
                                    'value': true,
                                    'timestamp': DateTime.now(),
                                  }).then((response) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Sales()));
                                    Navigator.pop(context);
                                  });

                                  FirebaseFirestore.instance
                                      .runTransaction((transaction) async {
                                    final snapshot =
                                    await transaction.get(_reference);
                                    final newQuantity =
                                        snapshot.get('quantity') -
                                            int.parse(quantityController.text);
                                    transaction.update(_reference, {
                                      // 'name': _nameController.text,
                                      // 'category': _categoryController.text,
                                      // 'mrp': _mrpController.text,
                                      'quantity': newQuantity
                                    });
                                  }).then((value) {
                                    Navigator.pop(context);
                                  }, onError: (e) => Utils.showSnackBar(e.toString()));

                                  setState(() {
                                    nameController.clear();
                                    categoryController.clear();
                                    mrpController.clear();
                                    quantityController.clear();
                                    discountController.clear();
                                    dosController.clear();
                                    clientController.clear();
                                  });
                                }
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
                                discountController.clear();
                                dosController.clear();
                                clientController.clear();
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
            return const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E)));
          }),
    );
  }
}
