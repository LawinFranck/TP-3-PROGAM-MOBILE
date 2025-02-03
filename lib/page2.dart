import 'package:flutter/material.dart';
import 'package:tp3/navigation/enregistrement.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController categorieController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void _navigateToSaveContact() {
    if (_formKey.currentState!.validate()) {
      // Passer les données à la page SaveContactPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SaveContactPage(
            name: nameController.text,
            surname: surnameController.text,
            category: categorieController.text,
            phone: phoneController.text,
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
        title: const Text("Ajouter"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _navigateToSaveContact, // Enregistrer et passer à la page suivante
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
                  hintText: "Entrer nom",
                  validator: (value) =>
                  value!.trim().isEmpty ? "Entrer un nom s'il vous plaît" : null,
                ),
                const SizedBox(height: 12),

                buildInputLabel("Prénom"),
                buildTextFormField(
                  controller: surnameController,
                  hintText: "Entrer prénom",
                  validator: (value) =>
                  value!.trim().isEmpty ? "Entrer un prénom s'il vous plaît" : null,
                ),
                const SizedBox(height: 12),

                buildInputLabel("Catégorie"),
                buildTextFormField(
                  controller: categorieController,
                  hintText: "Entrer Catégorie",
                  validator: (value) =>
                  value!.trim().isEmpty ? "Entrer une catégorie s'il vous plaît" : null,
                ),
                const SizedBox(height: 12),

                buildInputLabel("Téléphone"),
                buildTextFormField(
                  controller: phoneController,
                  hintText: "+229 XX XX XX XX",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Entrer un numéro de téléphone s'il vous plaît";
                    }
                    if (!RegExp(r'^\+229\d{8}$').hasMatch(value)) {
                      return "Numéro invalide, format attendu : +229 XX XX XX XX";
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
