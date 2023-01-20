import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';


class AssetModel {
  String? code;
  String? name;

  AssetModel(this.code, this.name);

  AssetModel.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    code = snapshot.get('code');
    name = snapshot.get('name');
  }
}

enum AssetCat {all, travel, refurbishing, miscellaneous}

class ChipController extends GetxController {
  final _selectedChip = 0.obs;

  get selectedChip => _selectedChip.value;

  set selectedChip(index) => _selectedChip.value = index;
}

class FirestoreController extends GetxController {
  final CollectionReference _assetRef =
  FirebaseFirestore.instance.collection('asset');

  var assetList = <AssetModel>[].obs;

  final ChipController _chipController = Get.put(ChipController());

  @override
  void onInit() {
    assetList
        .bindStream(getAssets(AssetCat.values[_chipController.selectedChip]));
    super.onInit();
  }

  Stream<List<AssetModel>> getAssets(AssetCat category) {
    switch (category) {
      case AssetCat.all:
        Stream<QuerySnapshot> stream = _assetRef.snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return AssetModel.fromDocumentSnapshot(snap);
        }).toList());
      case AssetCat.travel:
        Stream<QuerySnapshot> stream =
        _assetRef.where('category', isEqualTo: 'Travel').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return AssetModel.fromDocumentSnapshot(snap);
        }).toList());
      case AssetCat.refurbishing:
        Stream<QuerySnapshot> stream =
        _assetRef.where('category', isEqualTo: 'Refurbishing').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return AssetModel.fromDocumentSnapshot(snap);
        }).toList());
      case AssetCat.miscellaneous:
        Stream<QuerySnapshot> stream =
        _assetRef.where('category', isEqualTo: 'Miscellaneous').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
          return AssetModel.fromDocumentSnapshot(snap);
        }).toList());
    }
  }
}

class CategoryFilters extends StatelessWidget {
  CategoryFilters({Key? key}) : super(key: key);

  final FirestoreController firestoreController =
  Get.put(FirestoreController());

  final ChipController chipController = Get.put(ChipController());

  final List<String> _chipLabel = ['All', 'Travel', 'Refurbishing', 'Misc'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A233E),
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
                  () => Wrap(
                spacing: 20,
                children: List<Widget>.generate(4, (int index) {
                  return ChoiceChip(
                    label: Text(_chipLabel[index]),
                    selected: chipController.selectedChip == index,
                    onSelected: (bool selected) {
                      chipController.selectedChip = selected ? index : null;
                      firestoreController.onInit();
                      firestoreController.getAssets(
                          AssetCat.values[chipController.selectedChip]);
                    },
                  );
                }),
              ),
            ),
            Obx(() => Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    // physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: firestoreController.assetList.length,
                    itemBuilder: (BuildContext context, int index) {
                      const SizedBox(height: 10);
                      return Column(children: [
                        const SizedBox(height: 7),
                        Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${firestoreController.assetList[index].name}"),

                            ),
                          ),
                      ]);
                    })))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A233E),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCategory()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

TextEditingController codeController = TextEditingController();
TextEditingController nameController = TextEditingController();

final _formKey = GlobalKey<FormState>();

class _AddCategoryState extends State<AddCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A233E),
        title: const Text('Add Category'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    cursorColor: const Color(0xFF0a233e),
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Category Code!";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Category Code',
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
                        prefixIcon: const Icon(
                          Icons.numbers,
                          color: Color(0xFF0a233e),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => codeController.clear(),
                          color: const Color(0xFF0a233e),
                          icon: const Icon(Icons.clear),
                        )),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    cursorColor: const Color(0xFF0a233e),
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Category Name!";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Name',
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
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF0a233e),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => nameController.clear(),
                          color: const Color(0xFF0a233e),
                          icon: const Icon(Icons.clear),
                        )),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              codeController.text.isNotEmpty &&
                              nameController.text.isNotEmpty) {
                            FirebaseFirestore.instance.collection('vendor').add({
                              'code': codeController.text,
                              'name': nameController.text,
                              'timestamp': DateTime.now()
                            }).then((response) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryFilters()));
                            });

                            setState(() {
                              codeController.clear();
                              nameController.clear();
                            });

                          }
                        },
                        color: const Color(0xFF0a233e),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 40),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: const Color(0xFF0a233e),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


