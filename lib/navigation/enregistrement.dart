import 'package:flutter/material.dart';
import '../page2.dart';


class SaveContactPage extends StatefulWidget {
  final List<Map<String, String>> contacts;

  const SaveContactPage({super.key, required this.contacts});

  @override
  _SaveContactPageState createState() => _SaveContactPageState();
}

class _SaveContactPageState extends State<SaveContactPage> {
  late List<Map<String, String>> contacts;

  @override
  void initState() {
    super.initState();
    contacts = List.from(widget.contacts); // Initialisation correcte
    requestPermission();
  }

  Future<void> requestPermission(dynamic Permission) async {
    if (await Permission.contacts.request().isGranted) {
      fetchContacts();
    }
  }

  Future<void> fetchContacts() async {
    Iterable<Contact> fetchedContacts = await ContactsService.getContacts();
    setState(() {
      contacts = fetchedContacts.map((contact) => {
        'name': contact.givenName ?? '',
        'surname': contact.familyName ?? '',
        'phone': contact.phones?.isNotEmpty == true ? contact.phones!.first.value ?? '' : ''
      }).toList();
    });
  }

  void addContact(String name, String surname, String phone) async {
    Contact newContact = Contact(
      givenName: name,
      familyName: surname,
      phones: [Item(label: 'mobile', value: phone)],
    );

    await ContactsService.addContact(newContact);
    setState(() {
      contacts.add({
        'name': name,
        'surname': surname,
        'phone': phone,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddContactPage(contacts: contacts),
            ),
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

  void _callContact(String phoneNumber) {
    // Implémentation de l'appel (par exemple en utilisant url_launcher)
  }
}

class Item {
}

class ContactsService {
  static getContacts() {}

  static addContact(Contact newContact) {}
}

class Contact {
  get givenName => null;

  get familyName => null;

  get phones => null;
}
