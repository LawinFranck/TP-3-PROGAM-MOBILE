import 'package:flutter/material.dart';
import 'package:tp3/page2.dart';
import 'package:url_launcher/url_launcher.dart';

class SaveContactPage extends StatefulWidget {
  final String name;
  final String surname;
  final String category;
  final String phone;
  final List<Map<String, String>> contacts;

  const SaveContactPage({
    super.key,
    required this.name,
    required this.surname,
    required this.category,
    required this.phone,
    required this.contacts,
  });

  @override
  _SaveContactPageState createState() => _SaveContactPageState();
}

class _SaveContactPageState extends State<SaveContactPage> {
  late List<Map<String, String>> contacts;

  @override
  void initState() {
    super.initState();
    contacts = widget.contacts;
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
      appBar: AppBar(
        title: const Text("Contacts"),
        actions: [
          IconButton(
            onPressed: () {
              // Fonctionnalité de recherche à implémenter
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              // Fonctionnalité du menu à implémenter
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContactPage(contacts: contacts)),
          );

          if (newContact != null && newContact is Map<String, String>) {
            addContact(newContact['name']!, newContact['surname']!, newContact['phone']!);
          }
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
    );
  }
}
