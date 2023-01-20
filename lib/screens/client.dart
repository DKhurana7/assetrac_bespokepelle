import 'package:assetrac_bespokepelle/screens/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClientMaster extends StatefulWidget {
  ClientMaster({Key? key}) : super(key: key) {
    stream = _reference.orderBy('code').snapshots();
  }

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('client');
  late final Stream<QuerySnapshot> stream;

  @override
  State<ClientMaster> createState() => _ClientMasterState();
}

class _ClientMasterState extends State<ClientMaster> {
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
                        builder: (context) => const AlgoliaSearch(
                            indexName: 'client',
                            imgName:
                                'https://i1.wp.com/www.slntechnologies.com/wp-content/uploads/2017/08/ef3-placeholder-image.jpg?ssl=1')));
              },
            )
          ],
          centerTitle: true,
          backgroundColor: const Color(0xFF0a233e),
          title: const Text('Client Master')),
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
                        'code': e['code'],
                        'name': e['name'],
                        'companyName': e['companyName'],
                        'contact': e['contact'],
                      })
                  .toList();

              return ListView.builder(
                  padding: const EdgeInsets.all(5.0),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map thisItem = items[index];
                    return Card(
                      child: ExpansionTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        collapsedIconColor: const Color(0XFF0A233E),
                        textColor: const Color(0XFF0A233E),
                        collapsedTextColor: const Color(0XFF0A233E),
                        iconColor: const Color(0XFF0A233E),
                        title: Text(thisItem['companyName']),
                        subtitle: Text(thisItem['name']),
                        // trailing: IconButton(
                        //   icon: const Icon(Icons.arrow_drop_down,
                        //       color: Color(0XFF0A233E)),
                        //   onPressed: () {},
                        // ),
                        children: [
                          ListTile(
                            title: Text(thisItem['contact']),
                            subtitle: Text(thisItem['id']
                                .toString()
                                .substring(0, 10)),
                            trailing: IconButton(icon: const Icon(Icons.more_vert),color: const Color(0XFF0A233E), onPressed: () {},),
                          )
                        ],
                      ),
                    );
                  });
            }
            return const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0a233e),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddClient()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum MenuItem { item1, item2, item3 }

late Map data;

class ClientDetails extends StatelessWidget {
  ClientDetails(this.itemId, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('client').doc(itemId);
    _futureData = _reference.get();
  }

  final String itemId;
  late final DocumentReference _reference;
  late final Future<DocumentSnapshot> _futureData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Client Details'),
        backgroundColor: const Color(0xFF0a233e),
        actions: [
          PopupMenuButton<MenuItem>(
              onSelected: (value) async {
                data['id'] = itemId;
                if (value == MenuItem.item1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditClient(data)));
                } else if (value == MenuItem.item2) {
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: AlertDialog(
                            actionsPadding: const EdgeInsets.all(10.0),
                            backgroundColor: const Color(0xFF0a233e),
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
                                },
                                child: const Text("Delete",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              OutlinedButton(
                                onPressed: Navigator.of(context).pop,
                                child: const Text("Cancel",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
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
                    // Center(
                    //   child: Container(
                    //     height: 400,
                    //     width: 400,
                    //     decoration: BoxDecoration(
                    //         image: DecorationImage(
                    //             fit: BoxFit.cover,
                    //             image: NetworkImage(data['img'])
                    //           //   image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/assetmanagement-1e91f.appspot.com/o/images%2F1667761511575?alt=media&token=d634c0d1-ea81-4811-a4ff-c71d88c79c37")
                    //         )
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    const Text(
                      "Vendor Code:",
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xff0a233e)),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      itemId.substring(0, 10),
                      style: const TextStyle(
                          fontSize: 30,
                          color: Color(0xff0a233e),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Vendor Name: ",
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xff0a233e)),
                    ),
                    const SizedBox(height: 10),
                    Text(data['name'],
                        style: const TextStyle(
                            fontSize: 30.0,
                            color: Color(0xff0a233e),
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    const Text("Vendor Company Name",
                        style: TextStyle(
                            fontSize: 20.0, color: Color(0xff0a233e))),
                    const SizedBox(height: 10, width: 200),
                    Text(data['companyName'],
                        style: const TextStyle(
                          color: Color(0xff0a233e),
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 20, width: 200),
                    const Text("Vendor Contact Details:",
                        style: TextStyle(
                            fontSize: 20.0, color: Color(0xff0a233e))),
                    const SizedBox(height: 10, width: 200),
                    Text(data['contact'],
                        style: const TextStyle(
                            fontSize: 30.0,
                            color: Color(0xff0a233e),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class EditClient extends StatefulWidget {
  EditClient(this._assetItem, {Key? key}) : super(key: key) {
    _codeController = TextEditingController(text: _assetItem['code']);
    _nameController = TextEditingController(text: _assetItem['name']);
    _companyNameController =
        TextEditingController(text: _assetItem['companyName']);
    _contactController = TextEditingController(text: _assetItem['contact']);

    _reference =
        FirebaseFirestore.instance.collection('client').doc(_assetItem['id']);
  }

  final Map _assetItem;
  late final DocumentReference _reference;

  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _companyNameController;
  late final TextEditingController _contactController;

  @override
  State<EditClient> createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0a233e),
        title: const Text("Edit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: widget._codeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      labelText: "Client Code",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the client code";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: widget._nameController,
                  decoration: InputDecoration(
                      labelText: "Client Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the client name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: widget._companyNameController,
                  decoration: InputDecoration(
                      labelText: "Client Company Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the client company name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: widget._contactController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                      labelText: "Client Contact",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the client contact number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF0a233e))),
                        onPressed: () {
                          setState(() {
                            if (_key.currentState!.validate()) {
                              String code = widget._codeController.text;
                              String name = widget._nameController.text;
                              String companyName =
                                  widget._companyNameController.text;
                              String contact = widget._contactController.text;

                              Map<String, String> dataToUpdate = {
                                'code': code,
                                'name': name,
                                'companyName': companyName,
                                'contact': contact
                              };

                              widget._reference.update(dataToUpdate);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ClientDetails(data['id'])));
                            }
                          });
                        },
                        child: const Text("Update")),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF0a233e))),
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

class AddClient extends StatefulWidget {
  const AddClient({Key? key}) : super(key: key);

  @override
  State<AddClient> createState() => _AddClientState();
}

TextEditingController codeController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController companyNameController = TextEditingController();
TextEditingController contactController = TextEditingController();

final _formKey = GlobalKey<FormState>();

class _AddClientState extends State<AddClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A233E),
        title: const Text('Add Client'),
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
                        return "Enter Client Code!";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Client Code',
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
                        return "Enter Client Name!";
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
                  TextFormField(
                    cursorColor: const Color(0xFF0a233e),
                    controller: companyNameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Client Company Name!";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Company Name',
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
                          Icons.title,
                          color: Color(0xFF0a233e),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => nameController.clear(),
                          color: const Color(0xFF0a233e),
                          icon: const Icon(Icons.clear),
                        )),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    cursorColor: const Color(0xFF0a233e),
                    controller: contactController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Client Contact!";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Contact Number',
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
                          Icons.contact_phone_rounded,
                          color: Color(0xFF0a233e),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => nameController.clear(),
                          color: const Color(0xFF0a233e),
                          icon: const Icon(Icons.clear),
                        )),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              codeController.text.isNotEmpty &&
                              nameController.text.isNotEmpty &&
                              companyNameController.text.isNotEmpty &&
                              contactController.text.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection('client')
                                .add({
                              'code': codeController.text,
                              'name': nameController.text,
                              'companyName': companyNameController.text,
                              'contact': contactController.text,
                              'img': '',
                              'timestamp': DateTime.now()
                            }).then((response) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => ClientMaster()));
                            });

                            setState(() {
                              codeController.clear();
                              nameController.clear();
                              companyNameController.clear();
                              contactController.clear();
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
