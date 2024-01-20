import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({super.key});

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  // banco cloud firebase
  FirebaseFirestore db = FirebaseFirestore.instance;

  final TextEditingController _textController = TextEditingController();
  List<String> listNames = [];

  @override
  void initState() {
    // Atualização inicial
    refresh();
    // Atualização em tempo real
    db.collection("contatos").snapshots().listen((query) {
      listNames = [];
      query.docs.forEach((doc) {
        setState(() {
          listNames.add(doc.get("name"));
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha pequena agenda"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => refresh(),
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "vamos gravar um nome na nuvem?",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: "Insira um nome"),
            ),
            ElevatedButton(
                onPressed: () => sendData(), child: const Text("Enviar")),
            const SizedBox(
              height: 16,
            ),
            (listNames.length == 0)
                ? const Text("Nenhum contato registrado")
                : Column(
                    children: [for (String s in listNames) Text(s)],
                  )
          ],
        ),
      ),
    );
  }

  void refresh() async {
    // Atualização manual
    QuerySnapshot query = await db.collection("contatos").get();

    listNames = [];

    query.docs.forEach((doc) {
      String name = doc.get("name");
      setState(() {
        listNames.add(name);
      });
    });
  }

  void sendData() {
    // Geração do ID
    String id = const Uuid().v1();
    db.collection("contatos").doc(id).set({
      "name": _textController.text,
    });

    //Feedback Visual
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Salvo no FireStore")));
  }
}
