import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Map<String, dynamic>> postsData = [];
  List<Map<String, dynamic>> usuariosData = [];
  String urlImagePost = '';
  String textPost = '';
  String data = '';

  @override
  void initState() {
    super.initState();
    _carregarPosts();
    _carregarUsuarios();
  }

  Future<void> _carregarPosts() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collectionGroup("posts").get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> posts = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        setState(() {
          postsData = posts;
        });
      }
    } catch (e) {
      print("Erro ao obter dados do Firebase: $e");
    }
  }

  List<String> namesData = [];

  Future<void> _carregarUsuarios() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("usuarios").get();

      if (querySnapshot.docs.isNotEmpty) {
        List<String> names =
            querySnapshot.docs.map((doc) => doc["name"] as String).toList();

        setState(() {
          namesData = names;
          print(namesData);
        });
      }
    } catch (e) {
      print("Erro ao obter dados do Firebase: $e");
    }
  }

  // Cloud Firebase
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; // # Captura Width e Height da tela

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 5),
            color: Colors.white,
            width: size.width,
            child: Column(
              children: postsData.map((postData) {
                if (postData['done'] == false) {
                  var dataPost = postData['data'] != null
                      ? postData['data'] as Timestamp
                      : null;
                  var dataFormatada = dataPost != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(dataPost.toDate())
                      : ''; // Converte Timestamp para String

                  return Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 5),
                            child: Icon(
                              Icons.account_circle_rounded,
                              size: 50,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("USER"),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(dataFormatada),
                                Text(
                                    "${postData['bairro']}, ${postData['cidade']}"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PopupMenuButton<String>(
                              onSelected: (String value) {
                                // Lógica para cada opção do menu
                                if (value == 'Configurar') {
                                  print('Configurar selecionado!');
                                } else if (value == 'Outra Opção') {
                                  print('Outra Opção selecionada!');
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return ['Configurar', 'Outra Opção']
                                    .map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 10, left: 5),
                                child: Icon(Icons.settings),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(postData['text'] ?? ''),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (postData['urlImage'].isNotEmpty)
                        Column(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  width: size.width,
                                  height: 400,
                                  child: Image.file(
                                    File(postData['urlImage']),
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  postData['done'] = !postData['done'];
                                });
                              },
                              icon: Icon(
                                postData['done'] ? Icons.check : Icons.close,
                                color: postData['done']
                                    ? Colors.green
                                    : Colors.red,
                                size: 40,
                              ),
                            )
                          ],
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 15,
                        color: Colors.grey[200],
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }).toList(),
            )),
      ),
    );
  }
}
