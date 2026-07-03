import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/add/add_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference dbRef =
  FirebaseFirestore.instance.collection("users");

  List<Map<String, dynamic>> users = [];
  List<String> userIds = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    users.clear();
    userIds.clear();

    final data = await dbRef.get();

    for (var doc in data.docs) {
      users.add(doc.data() as Map<String, dynamic>);
      userIds.add(doc.id);
    }

    setState(() {});
  }

  Future<void> deleteData(String id) async {
    await dbRef.doc(id).delete();
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database"),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.3,
                ),
              ),
            ),
            child: ListTile(
              title: Text(users[index]["name"] ?? ""),
              subtitle: Text(users[index]["email"] ?? ""),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  await deleteData(userIds[index]);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddScreen(),
            ),
          );
          await fetchData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}