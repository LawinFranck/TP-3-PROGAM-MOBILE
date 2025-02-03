import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../page2.dart';

class SaveContactPage extends StatefulWidget {
  final String name;
  final String surname;
  final String category;
  final String phone;

  const SaveContactPage({
    super.key,
    required this.name,
    required this.surname,
    required this.category,
    required this.phone,
  });

  @override
  _SaveContactPageState createState() => _SaveContactPageState();
}

class _SaveContactPageState extends State<SaveContactPage> {
   List<Map<String, String>> contacts = [];

  @override
  void initState() {
    super.initState();
    // Ajouter le premier contact au chargement de la page
    addContact(widget.name, widget.surname, widget.phone);
  }

  void addContact(String name, String surname, String phone) {
    setState(() {
      contacts.add({
        "name": name,
        "surname": surname,
        "phone": phone,
      });
    });
  }

  void _callContact(String phone) async {
    final Uri url = Uri(scheme: "tel", path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Impossible de passer l'appel")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Scaffold(
    appBar: AppBar(
    title: Text("Contacts"),
    actions: [
    Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    IconButton(onPressed: (){

    },
    icon: Icon(Icons.search),
    ),

    IconButton(onPressed: () {

    },
    icon: Icon(Icons.more_vert),
    )
    ],
    )
    ],),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => const AddContactPage()),
          );
        },
        backgroundColor: const Color(0xFF00B2FF),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        "${contact['name']} ${contact['surname']}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        contact['phone']!,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.phone, color: Colors.green),
                        onPressed: () => _callContact(contact['phone']!),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}
