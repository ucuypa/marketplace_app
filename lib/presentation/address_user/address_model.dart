import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String street;
  final String city;
  final String zip;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.zip,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'street': street,
      'city': city,
      'zip': zip,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory AddressModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AddressModel(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      street: data['street'] ?? '',
      city: data['city'] ?? '',
      zip: data['zip'] ?? '',
    );
  }
}
