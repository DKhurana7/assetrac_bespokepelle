import 'package:cloud_firestore/cloud_firestore.dart';


class Asset {
  final String? id;
  final String name;
  final String category;

  const Asset({
    this.id,
    required this.name,
    required this.category
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category
    };
  }

  Asset.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!['name'],
        category = doc.data()!['category'];

}