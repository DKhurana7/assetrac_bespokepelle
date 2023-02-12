import 'dart:io';
import 'package:assetrac_bespokepelle/screens/list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage.dart';
import 'package:assetrac_bespokepelle/services/textformfield.dart';

late var xData;

class AddAssets extends StatefulWidget {
  const AddAssets({Key? key}) : super(key: key);

  @override
  State<AddAssets> createState() => _AddAssetsState();
}

class _AddAssetsState extends State<AddAssets> {
  File? imageFile;

  String imageUrl = '';

  Future pickImage(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: imageSource);

    if (file == null) return;

    setState(() {
      imageFile = File(file.path);
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    //Getting a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    //Create a reference for the image to be stored

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      //Store the file
      await referenceImageToUpload.putFile(File(file.path));
      //  Success: get download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //  Some error occurred
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController mrpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? scanResult;

  @override
  Widget build(BuildContext context) {
    generatePreviewWidget(File file) {
      return FileImage(file);
    }

    final Storage storage = Storage();

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0XFF0A233E),
        title: const Text('Add Asset'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('category').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if (snapshot.hasError) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {

              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;

              List<Map> items = documents
                  .map((e) => {
                        'id': e.id,
                        'name': e['name'],
                      })
                  .toList();

              Map<dynamic, dynamic>? selectedValue;

              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InkWell(
                              child: CircleAvatar(
                                  backgroundColor: const Color(0XFF0A233E),
                                  radius: 75,
                                  backgroundImage: imageFile != null
                                      ? generatePreviewWidget(imageFile!)
                                      : null,
                                  child: imageFile != null
                                      ? null
                                      : const Icon(Icons.camera_alt,
                                          color: Colors.white)),
                              onTap: () async {
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: SizedBox(
                                          height: 200,
                                          child: AlertDialog(
                                            backgroundColor:
                                                const Color(0XFF0A233E),
                                            actionsPadding:
                                                const EdgeInsets.all(10.0),
                                            content: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        pickImage(ImageSource
                                                            .gallery);
                                                      },
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .white)),
                                                      child: const Text(
                                                        "Gallery",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white)),
                                                    onPressed: () {
                                                      pickImage(
                                                          ImageSource.camera);
                                                    },
                                                    child: const Text(
                                                      "Camera",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                          FutureBuilder(
                              future: storage.listFiles(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<firebase_storage.ListResult>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return Container();
                                }
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    snapshot.hasData) {
                                  return const CircularProgressIndicator(
                                      color: Color(0XFF0A233E));
                                }
                                return Container();
                              }),
                          const SizedBox(height: 40),
                          // StreamBuilder<QuerySnapshot>(
                          //     stream: FirebaseFirestore.instance
                          //         .collection('category')
                          //         .snapshots(),
                          //     builder: (context, AsyncSnapshot snapshot) {
                          DropdownSearch<Map<dynamic, dynamic>>(
                            items: items,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Select Category',
                                labelStyle: const TextStyle(
                                  color: Color(0XFF0A233E),
                                ),
                                prefixIcon: const Icon(Icons.category,
                                    color: Color(0XFF0A233E)),
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
                                  categoryController.text = xData['name'];
                                });
                              },
                              child: const Text(
                                'Choose',
                                style: TextStyle(color: Colors.white),
                              )),
                          const SizedBox(height: 20),
                          // TextFormFieldCard(controller: categoryController,
                          //     enabled: true,
                          //     keyboardType: TextInputType.text,
                          //     inputFormatters: <TextInputFormatter>[
                          //       FilteringTextInputFormatter.singleLineFormatter
                          //     ],
                          //     labelText: 'Category',
                          //     prefixIcon: Icons.category,
                          //     validatorText: 'Enter Asset Category'),
                          // const SizedBox(height: 20),
                          TextFormFieldCard(
                              controller: nameController,
                              enabled: true,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              labelText: 'Name',
                              prefixIcon: Icons.web_asset,
                              validatorText: 'Enter Asset Name'),
                          const SizedBox(height: 20),
                          TextFormFieldCard(
                              controller: mrpController,
                              enabled: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              labelText: 'MRP',
                              prefixIcon: FontAwesomeIcons.indianRupeeSign,
                              validatorText: 'Enter Asset MRP'),
                          const SizedBox(height: 20),
                          TextFormFieldCard(
                              controller: remarksController,
                              enabled: true,
                              keyboardType: TextInputType.text,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.singleLineFormatter
                              ],
                              labelText: 'Remarks',
                              prefixIcon: Icons.info),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                  // Navigator.pop(context);
                                  if (_formKey.currentState!.validate() &&
                                      nameController.text.isNotEmpty &&
                                      categoryController.text.isNotEmpty &&
                                      mrpController.text.isNotEmpty) {
                                    FirebaseFirestore.instance
                                        .collection('transaction')
                                        .add({
                                      'name': nameController.text,
                                      'category': categoryController.text,
                                      'mrp': mrpController.text,
                                      // 'remarks': remarksController.text,
                                      // 'img': imageUrl,
                                      'quantity': 0,
                                      'timestamp': DateTime.now()
                                    });
                                    FirebaseFirestore.instance
                                        .collection('asset')
                                        .add({
                                      'name': nameController.text,
                                      'category': categoryController.text,
                                      'mrp': mrpController.text,
                                      'remarks': remarksController.text,
                                      'img': imageUrl,
                                      'timestamp': DateTime.now()
                                    }).then((response) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AssetList()));
                                      Navigator.pop(context);
                                    });
                                    setState(() {
                                      nameController.clear();
                                      categoryController.clear();
                                      remarksController.clear();
                                      mrpController.clear();
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
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
