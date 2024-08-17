import 'package:contect/Contact_provider.dart';
import 'package:flutter/material.dart';

class Contact {
  late int phone;
  late String name;
  String? Imageurl;
  Contact({required this.phone, required this.name, this.Imageurl});
  Contact.fromMap(Map<String, dynamic> map) {
    phone = map[Columnphone] ?? 0;
    name = map[ColumnName] ?? "";
    if (map[ColumnImageurl] != null) {
      Imageurl = map[ColumnImageurl];
    }
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[Columnphone] = this.phone;
    map[ColumnName] = this.name;
    if (map[ColumnImageurl] != null) {
      Imageurl = map[ColumnImageurl];
    }
    return map;
  }
}
