import 'package:contect/Contact_provider.dart';
import 'package:contect/contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ContactProvider.instance.open();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _Homestate createState() => _Homestate();
}

class _Homestate extends State<Home> {
  List<Contact> contactList = [];
  @override
  void initState() {
    super.initState();
    _loadinitialcontacts();
  }

  Future<void> _loadinitialcontacts() async {
    List<Contact> initialcontact = [
      Contact(
          phone: 0123645987,
          name: "Farah",
          Imageurl:
              "https://upload.wikimedia.org/wikipedia/commons/b/b7/Google_Contacts_logo.png"),
      Contact(
          phone: 0125698743,
          name: "Osama",
          Imageurl:
              "https://upload.wikimedia.org/wikipedia/commons/b/b7/Google_Contacts_logo.png"),
      Contact(
          phone: 012459863,
          name: "Mohamed",
          Imageurl:
              "https://upload.wikimedia.org/wikipedia/commons/b/b7/Google_Contacts_logo.png"),
      Contact(
          phone: 0120126834,
          name: "Seif",
          Imageurl:
              "https://upload.wikimedia.org/wikipedia/commons/b/b7/Google_Contacts_logo.png"),
    ];
    for (Contact contacts in initialcontact) {
      await ContactProvider.instance.insert(contacts);
    }
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final books = await ContactProvider.instance.getcontact();
    setState(() {
      contactList = books;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Contact",
          style: TextStyle(
              color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Contact>>(
        future: ContactProvider.instance.getcontact(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            contactList = snapshot.data!;
            return GridView.builder(
              itemCount: contactList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                Contact contact = contactList[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      contact.Imageurl != null
                          ? Image.network(
                              contact.Imageurl!,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                            )
                          : Icon(Icons.image_not_supported),
                      Text(contact.name),
                      Text(contact.phone.toString()),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No contacts available"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _addcontact(context);
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _addcontact(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController phonecontroller = TextEditingController();
    TextEditingController urlController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  right: 10,
                  left: 10),
              child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Contact Name",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: phonecontroller,
                  decoration: const InputDecoration(
                    hintText: "Contact Number",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    hintText: " Contact Image url",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () async {
                    final name = nameController.text;
                    final phone = int.tryParse(phonecontroller.text);
                    final imageUrl = urlController.text;

                    if (name.isNotEmpty && phone != null) {
                      final contact = Contact(
                        name: name,
                        phone: phone,
                        Imageurl: imageUrl.isNotEmpty ? imageUrl : null,
                      );
                      await ContactProvider.instance.insert(contact);
                      _loadContacts();
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add"),
                ),
              ])));
        });
  }
}
