// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:assetrac_bespokepelle/screens/add_asset.dart';
import 'package:assetrac_bespokepelle/screens/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AssetList extends StatefulWidget {
  AssetList({Key? key}) : super(key: key) {
    stream = _reference.orderBy('name').snapshots();
  }

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('asset');
  late Stream<QuerySnapshot> stream;

  @override
  State<AssetList> createState() => _AssetListState();
}

class _AssetListState extends State<AssetList> {
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
                        builder: (context) => const AlgoliaAssetSearch()));
              },
            )
          ],
          centerTitle: true,
          backgroundColor: const Color(0XFF0A233E),
          title: const Text('Asset Master')),
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
                        'remarks': e['remarks'],
                        'image': e['img'],
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AssetDetails(
                                            thisItem['id'])));
                          },
                          contentPadding: const EdgeInsets.all(10.0),
                          leading: CircleAvatar(
                            backgroundColor: const Color(0XFF0A233E),
                            radius: 25.0,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          thisItem['image']))),
                            ),
                          ),
                          title: Text(thisItem['name']),
                          subtitle: Text(thisItem['category'],
                        ),
                        )],
                    );
                  });
            }
            return const Center(
                child: CircularProgressIndicator(color: Color(0XFF0A233E)));
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0XFF0A233E),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddAssets()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum MenuItem { item1, item2, item3 }

late Map data;

class AssetDetails extends StatelessWidget {
  AssetDetails(this.itemId, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('asset').doc(itemId);
    _futureData = _reference.get();
  }

  String itemId;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Asset Details'),
        backgroundColor: const Color(0XFF0A233E),
        actions: [
          PopupMenuButton<MenuItem>(
              onSelected: (value) async {
                data['id'] = itemId;
                if (value == MenuItem.item1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditAsset(data)));
                } else if (value == MenuItem.item2) {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: Deletion(reference: _reference),
                        );
                      });
                }
              },
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: MenuItem.item1,
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: MenuItem.item2,
                      child: Text('Delete'),
                    ),
                  ])
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some Error Occurred ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data;
            data = documentSnapshot.data() as Map;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(data['img']))),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Asset Code:",
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0XFF0A233E)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      itemId.substring(0, 10),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Color(0XFF0A233E),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Asset Name: ",
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0XFF0A233E)),
                    ),
                    const SizedBox(height: 10),
                    Text(data['name'],
                        style: const TextStyle(
                            fontSize: 30.0,
                            color: Color(0XFF0A233E),
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const Text("Asset Category:",
                        style: TextStyle(
                            fontSize: 20.0, color: Color(0XFF0A233E))),
                    const SizedBox(height: 10, width: 200),
                    Text(data['category'],
                        style: const TextStyle(
                          color: Color(0XFF0A233E),
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 20),
                    const Text("Asset MRP:",
                        style: TextStyle(
                            fontSize: 20.0, color: Color(0XFF0A233E))),
                    Text('₹${data['mrp']}',
                        style: const TextStyle(
                            fontSize: 30.0,
                            color: Color(0XFF0A233E),
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20, width: 200),
                    const Text("Asset Remarks:",
                        style: TextStyle(
                            fontSize: 20.0, color: Color(0XFF0A233E))),
                    const SizedBox(height: 10, width: 200),
                    Text(data['remarks'] == "" ? 'None' : data['remarks'],
                        style: const TextStyle(
                            fontSize: 30.0,
                            color: Color(0XFF0A233E),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }
          return const Center(
              child: CircularProgressIndicator(color: Color(0XFF0A233E)));
        },
      ),
    );
  }
}

class Deletion extends StatelessWidget {
  const Deletion({
    Key? key,
    required DocumentReference<Object?> reference,
  })  : _reference = reference,
        super(key: key);

  final DocumentReference<Object?> _reference;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.all(10.0),
      backgroundColor: const Color(0XFF0A233E),
      title: const Text(
        "Deletion",
        style: TextStyle(color: Colors.white),
      ),
      content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "Are you sure you want to delete?",
              style: TextStyle(color: Colors.white),
            )
          ]),
      actions: [
        OutlinedButton(
          onPressed: () {
            _reference.delete();
            Navigator.pop(context);
            Navigator.pop(context);
            // Navigator.push(context, MaterialPageRoute(builder: (context) => AssetList()));
          },
          child: const Text("Delete", style: TextStyle(color: Colors.white)),
        ),
        OutlinedButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class EditAsset extends StatelessWidget {
  EditAsset(this._assetItem, {Key? key}) : super(key: key) {
    _nameController = TextEditingController(text: _assetItem['name']);
    _categoryController = TextEditingController(text: _assetItem['category']);
    _mrpController = TextEditingController(text: _assetItem['mrp'].toString());
    _remarksController = TextEditingController(text: _assetItem['remarks']);

    _reference =
        FirebaseFirestore.instance.collection('asset').doc(_assetItem['id']);
  }

  final Map _assetItem;
  late DocumentReference _reference;

  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _remarksController;
  late TextEditingController _mrpController;

  // File? imageFile;
  //
  // String imageUrl = '';
  //
  // Future pickImage(ImageSource imageSource) async {
  //   ImagePicker imagePicker = ImagePicker();
  //   XFile? file = await imagePicker.pickImage(source: imageSource);
  //
  //   if (file == null) return;
  //
  //   // setState(() {
  //   // imageFile = File(file.path);
  //   // });
  //
  //   String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   //
  //   // //Getting a reference to storage root
  //   // Reference referenceRoot = FirebaseStorage.instance.ref();
  //   // Reference referenceDirImages = referenceRoot.child('images');
  //   // //Create a reference for the image to be stored
  //   //
  //   // Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
  //
  //   Reference referenceImageToUpload =
  //       FirebaseStorage.instance.refFromURL(_assetItem['img']);
  //
  //   try {
  //     //Store the file
  //     await referenceImageToUpload.putFile(File(file.path));
  //     //  Success: get download URL
  //     imageUrl = await referenceImageToUpload.getDownloadURL();
  //   } catch (error) {
  //     //  Some error occurred
  //   }
  // }

  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
  //   generatePreviewWidget(File file) {
  //     return FileImage(file);
  //   }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0XFF0A233E),
        title: const Text("Edit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // InkWell(
                //     child: CircleAvatar(
                //         backgroundColor: const Color(0XFF0A233E),
                //         radius: 75,
                //         backgroundImage: imageFile != null
                //             ? generatePreviewWidget(imageFile!)
                //             : null,
                //         child: imageFile != null
                //             ? null
                //             : const Icon(Icons.camera_alt,
                //                 color: Colors.white)),
                //     onTap: () async {
                //       return showDialog(
                //           context: context,
                //           builder: (context) {
                //             return Center(
                //               child: SizedBox(
                //                 height: 200,
                //                 child: AlertDialog(
                //                   backgroundColor: const Color(0XFF0A233E),
                //                   actionsPadding: const EdgeInsets.all(10.0),
                //                   content: Center(
                //                     child: Column(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.center,
                //                       crossAxisAlignment:
                //                           CrossAxisAlignment.center,
                //                       children: [
                //                         ElevatedButton(
                //                             onPressed: () {
                //                               pickImage(ImageSource.gallery);
                //                             },
                //                             style: ButtonStyle(
                //                                 backgroundColor:
                //                                     MaterialStateProperty.all(
                //                                         Colors.white)),
                //                             child: const Text(
                //                               "Gallery",
                //                               style: TextStyle(
                //                                   color: Colors.black),
                //                             )),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                         ElevatedButton(
                //                           style: ButtonStyle(
                //                               backgroundColor:
                //                                   MaterialStateProperty.all(
                //                                       Colors.white)),
                //                           onPressed: () {
                //                             pickImage(ImageSource.camera);
                //                           },
                //                           child: const Text(
                //                             "Camera",
                //                             style:
                //                                 TextStyle(color: Colors.black),
                //                           ),
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             );
                //           });
                //     }),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: "Asset Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the asset name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                      labelText: "Asset Category",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the asset category";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _mrpController,
                  decoration: InputDecoration(
                      labelText: "Asset MRP",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the asset mrp";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _remarksController,
                  decoration: InputDecoration(
                      labelText: "Asset Remarks",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  // validator: (String? value) {
                  //   if (value == null || value.isEmpty) {
                  //     return "Please enter the asset remarks";
                  //   }
                  //   return 'None';
                  // },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0XFF0A233E))),
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            String name = _nameController.text;
                            String category = _categoryController.text;
                            String mrp = _mrpController.text;
                            String remarks = _remarksController.text;

                            Map<String, String> dataToUpdate = {
                              'name': name,
                              'category': category,
                              'mrp': mrp,
                              'remarks': remarks,
                              // 'img': imageUrl
                            };


                            _reference.update(dataToUpdate);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AssetDetails(data['id'])));
                          }
                        },
                        child: const Text("Update")),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0XFF0A233E))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
