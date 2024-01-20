import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio/components/decoration_field_authentication.dart';
import 'package:desafio/pages/feed/feed_page.dart';
import 'package:desafio/pages/home/home_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
/* import 'package:http/http.dart' as http;
import 'dart:convert'; */
import 'package:desafio/utils/my_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  // Cloud Firebase
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Form Controllers
  final _cepController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _bairroController = TextEditingController();
  final _ruaController = TextEditingController();
  /* final _textController = TextEditingController();
  final _titleController = TextEditingController(); */

  // Form Key
  final _globalKey = GlobalKey<FormState>();

  // Image
  XFile? photo;
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;
  bool uploading = false;
  double total = 0;

  Future<String?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() => photo = file);
    print("============${photo?.path}=================");
    return photo?.path;
  }

  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpeg';
      final storageRef = FirebaseStorage.instance.ref();
      return storageRef.child(ref).putFile(
            file,
            SettableMetadata(
              cacheControl: "public, max-age=300",
              contentType: "image/jpeg",
              customMetadata: {
                "user": "123",
              },
            ),
          );
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  uploadData() async {
    if (photo?.path != null) {
      UploadTask task = await upload(photo!.path);
      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            uploading = true;
            total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if (snapshot.state == TaskState.success) {
          if (mounted) {
            final photoRef = snapshot.ref;
            arquivos.add(await photoRef.getDownloadURL());
            refs.add(photoRef);
            setState(() => uploading = false);
          }
          /* final photoRef = snapshot.ref;
          arquivos.add(await photoRef.getDownloadURL());
          refs.add(photoRef);
          setState(() => uploading = false); */
        }
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Salvo no FireStore")));
    }
    // Geração do ID
    String id = const Uuid().v1();
    await db.collection("pots").doc(id).set({
      "cidade": _cidadeController.text,
      "bairro": _bairroController.text,
      "rua": _ruaController.text,
      "cep": _cepController.text,
      "urlImage": photo?.path,
    });
  }

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  void dispose() {
    _cepController.dispose();
    _cidadeController.dispose();
    _bairroController.dispose();
    _ruaController.dispose();

    super.dispose();
  }

  loadImages() async {
    refs = (await storage.ref('images').listAll()).items;
    for (var ref in refs) {
      final arquivo = await ref.getDownloadURL();
      arquivos.add(arquivo);
    }
    setState(() => loading = false);
  }

  deleteImage(int index) async {
    await storage.ref(refs[index].fullPath).delete();
    arquivos.removeAt(index);
    refs.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: uploading
            ? Text('${total.round()}% enviado')
            : const Text('Firebase Storage'),
        actions: [
          if (uploading)
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ],
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _cepController,
                    decoration: getAuthenticationInputDecoration("CEP"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _cidadeController,
                    decoration: getAuthenticationInputDecoration("Cidade"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _bairroController,
                    decoration: getAuthenticationInputDecoration("Bairro"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _ruaController,
                    decoration: getAuthenticationInputDecoration("Rua"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.attach_file),
                    title: const Text('Anexar foto'),
                    onTap: getImage,
                    trailing:
                        photo != null ? Image.file(File(photo!.path)) : null,
                  ),
                  TextButton(
                    onPressed: () {
                      uploadData();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            MyColors.secondaryColor)),
                    child: const Text("Enviar"),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Future<void> sendData() async {}
}




/* 

Scaffold(
      appBar: AppBar(
        title: const Text("Consultando um CEP via API"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Digite o CEP ex: 58345000"),
              ),
              Text(
                "Resultado: $resultado",
                style: const TextStyle(fontSize: 25),
              ),
              TextButton(
                onPressed: _consultaCep,
                child: const Text("COnsultar"),
              )
            ]),
      ),
    ); */



    // armazena o resultado da busca do CEP
  /* String resultado = ''; */

  // Método para buscar CEPs
 /*  _consultaCep() async {
    String cep = _cepController.text;
    String url = "https://viacep.com.br/ws/$cep/json/";

    http.Response response;

    response = await http.get(Uri.parse(url));

    Map<String, dynamic> retorno = json.decode(response.body);

    String logradouro = retorno["logradouro"];
    String cidade = retorno["localidade"];
    String bairro = retorno["bairro"];

    setState(() {
      resultado = "$logradouro + $cidade + $bairro";
    });
  } */