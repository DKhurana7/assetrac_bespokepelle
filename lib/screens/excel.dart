// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


List<List<dynamic>> testExcel = [
  <String>['Code', 'Name', 'Category', 'Remarks']
];

TextEditingController excelController = TextEditingController();

// ignore: prefer_typing_uninitialized_variables
var fName;

class Excel extends StatefulWidget {
  const Excel({Key? key}) : super(key: key);

  @override
  State<Excel> createState() => _ExcelState();
}

class _ExcelState extends State<Excel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: const Color(0XFF0A233E),
        centerTitle: true,
        title: const Text('CSV'),
      ),
      body: Column(
        children: [
          SizedBox(
            child: TextFormField(
              controller: excelController,
              onChanged: (value) {
                fName = value;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 25,
                ),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('asset').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E)));
                }
                return ListView(
                  children: snapshot.data!.docs.map((document) {

                    testExcel.add([
                      document['name'],
                      document['category'],
                      document['remarks']
                    ]);

                    return Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(document['name']),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0XFF0A233E),
        onPressed: () {
          generateCsv();
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}

generateCsv() async {
  print("GENERATE CSV WAS CLICKED");

  String csvData = const ListToCsvConverter().convert(testExcel);

  if (await Permission.manageExternalStorage.request().isGranted) {
    Directory generalDownloadDir = Directory('/storage/emulated/0/Download');

    final File file =
    await File('${generalDownloadDir.path}/asset_export_$fName.csv').create();

    await file.writeAsString(csvData);
  }
}
