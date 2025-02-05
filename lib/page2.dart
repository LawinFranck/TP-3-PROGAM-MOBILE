import 'package:flutter/material.dart';
import 'package:tp3/navigation/enregistrement.dart';

class AddContactPage extends StatefulWidget {
  final List<Map<String, String>> contacts;

  const AddContactPage({super.key, required this.contacts});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController categorieController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final newContact = {
        "name": nameController.text,
        "surname": surnameController.text,
        "category": categorieController.text,
        "phone": phoneController.text,
      };

      // Ajout du contact à la liste existante
      List<Map<String, String>> updatedContacts = List.from(widget.contacts);
      updatedContacts.add(newContact);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SaveContactPage(
            contacts: updatedContacts,
            name: newContact['name']!,
            surname: newContact['surname']!,
            category: newContact['category']!,
            phone: newContact['phone']!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Ajouter un contact"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveContact, // Sauvegarde du contact et retour à la liste
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInputLabel("Nom"),
                buildTextFormField(
                  controller: nameController,
                  hintText: "Entrer le nom",
                  validator: (value) =>
                  value!.trim().isEmpty ? "Veuillez entrer un nom" : null,
                ),
                const SizedBox(height: 12),

                buildInputLabel("Prénom"),
                buildTextFormField(
                  controller: surnameController,
                  hintText: "Entrer le prénom",
                  validator: (value) =>
                  value!.trim().isEmpty ? "Veuillez entrer un prénom" : null,
                ),
                const SizedBox(height: 12),

                buildInputLabel("Catégorie"),
                buildTextFormField(
                  controller: categorieController,
                  hintText: "Entrer la catégorie",
                  validator: (value) => value!.trim().isEmpty
                      ? "Veuillez entrer une catégorie"
                      : null,
                ),
                const SizedBox(height: 12),

                buildInputLabel("Téléphone"),
                buildTextFormField(
                  controller: phoneController,
                  hintText: "+22901XXXXXXXX",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Veuillez entrer un numéro de téléphone";
                    }
                    if (!RegExp(r'^\+229\d{10}$').hasMatch(value)) {
                      return "Format invalide : +22901XXXXXXXX";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
      validator: validator,
    );
  }
}
