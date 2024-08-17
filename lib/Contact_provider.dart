import 'package:contect/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String Columnphone = "phone";
final String ColumnImageurl = "Imageurl";
final String ColumnName = "name";
final String contacttable = "todo_table";

class ContactProvider {
  static final ContactProvider instance = ContactProvider._internal();

  factory ContactProvider() {
    return instance;
  }
  ContactProvider._internal();
  late Database db;
  Future open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), "contact.db"),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE $contacttable($ColumnName TEXT NOT NULL,$Columnphone INTEGER PRIMARY KEY,$ColumnImageurl TEXT NOT NULL)");
      },
    );
  }

  Future<Contact> insert(Contact contact) async {
    (await db.insert(contacttable, contact.toMap()));
    return contact;
  }

  Future<List<Contact>> getcontact() async {
    List<Map<String, dynamic>> contactMaps = await db.query(contacttable);
    if (contactMaps.isEmpty) {
      return [];
    } else {
      List<Contact> contacts =
          contactMaps.map((element) => Contact.fromMap(element)).toList();
      return contacts;
    }
  }

  Future<int> delete(String name) async {
    return await db
        .delete(contacttable, where: "$ColumnName=?", whereArgs: [name]);
  }

  Future<int> update(Contact contact) async {
    return await db.update(contacttable, contact.toMap(),
        where: "$ColumnName=?", whereArgs: [contact.name]);
  }
}
