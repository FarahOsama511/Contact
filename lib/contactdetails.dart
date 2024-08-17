import 'package:contect/Contact_provider.dart';
import 'package:contect/contact.dart';
import 'package:contect/main.dart';

import 'package:flutter/material.dart';

class Contactdetailpage extends StatefulWidget {
  final Contact contact;
  Contactdetailpage({Key? key, required this.contact}) : super(key: key);

  @override
  State<Contactdetailpage> createState() => _ContactdetailpageState();
}

class _ContactdetailpageState extends State<Contactdetailpage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController urlController = TextEditingController();
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.contact.name);
    phonecontroller =
        TextEditingController(text: widget.contact.phone.toString());
    urlController = TextEditingController(text: widget.contact.Imageurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Contact Details",
          style: TextStyle(
              color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15)
            .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/b/b7/Google_Contacts_logo.png"),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: widget.contact.name,
                    hintStyle:
                        TextStyle(color: Colors.grey[800], fontSize: 25)),
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: phonecontroller,
                decoration: InputDecoration(
                    hintText: widget.contact.phone.toString(),
                    hintStyle:
                        TextStyle(color: Colors.grey[800], fontSize: 25)),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                    hintText: widget.contact.Imageurl,
                    hintStyle:
                        TextStyle(color: Colors.grey[800], fontSize: 25)),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 50)),
                  onPressed: () async {
                    bool? confirmsave = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Save Contact",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              "Are you sure want to save this contact?",
                              style: TextStyle(fontSize: 20),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          );
                        });
                    if (confirmsave == true) {
                      setState(() {
                        widget.contact.name = nameController.text;
                        widget.contact.phone = int.parse(phonecontroller.text);
                        widget.contact.Imageurl = urlController.text;
                      });
                      await ContactProvider.instance.update(widget.contact);
                      Navigator.pop(context, widget.contact);
                    }
                  },
                  child: const Text(
                    "save",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () async {
                    bool? confirmsave = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Delete Contact",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              "Are you sure want to delete this contact?",
                              style: TextStyle(fontSize: 20),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ],
                          );
                        });
                    if (confirmsave == true) {
                      setState(() {
                        widget.contact.name = nameController.text;
                        widget.contact.phone = int.parse(phonecontroller.text);
                        widget.contact.Imageurl = urlController.text;
                      });
                      await ContactProvider.instance
                          .delete(widget.contact.name);
                      Navigator.pop(context, widget.contact);
                    }
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
