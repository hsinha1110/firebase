import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  final dbReference = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  hintText: "Name",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  hintText: "Email",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(    minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  try {
                    await dbReference.doc(id).set({
                      "id": id,
                      "name": name.text,
                      "email": email.text,
                    });
                    print("Data Added Successfully");
                    Navigator.pop(context);
                  } catch (e) {
                    print("Firestore Error => $e");
                  }
                },
                child: const Text("Add User"),
              )
            ],
          ),
        ),
      ),
    );
  }
}