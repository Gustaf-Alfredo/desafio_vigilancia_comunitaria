import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio/components/decoration_field_authentication.dart';
import 'package:desafio/pages/home/home_page.dart';
import 'package:desafio/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:desafio/utils/my_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({super.key});

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  // Cloud Firebase
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Firebase Storage
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Form Controllers
  final _cepController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _bairroController = TextEditingController();
  final _ruaController = TextEditingController();
  final _textController = TextEditingController();
  final _titleController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    // AUTH
    final authService = context.read<AuthService>();

    uploadData() async {
      if (_globalKey.currentState!.validate()) {
        if (photo?.path != null) {
          UploadTask task = await upload(photo!.path);
          task.snapshotEvents.listen((TaskSnapshot snapshot) async {
            if (mounted) {
              // Verifica se o widget ainda está montado antes de chamar setState
              if (snapshot.state == TaskState.running) {
                setState(() {
                  uploading = true;
                  total =
                      (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                });
              } else if (snapshot.state == TaskState.success) {
                if (mounted) {
                  // Verifica novamente antes de chamar setState
                  final photoRef = snapshot.ref;
                  arquivos.add(await photoRef.getDownloadURL());
                  refs.add(photoRef);
                  setState(() => uploading = false);
                }
              }
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Sua solicitação foi enviada com sucesso",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        // Geração do ID
        String id = const Uuid().v1();
        await db
            .collection("users/${authService.usuario!.uid}/posts")
            .doc(id)
            .set({
          "cidade": _cidadeController.text,
          "bairro": _bairroController.text,
          "rua": _ruaController.text,
          "cep": _cepController.text,
          "title": _titleController.text,
          "text": _textController.text,
          "urlImage": photo?.path,
          "done": false,
          "idAuth": authService.usuario!.uid,
          "data": FieldValue.serverTimestamp(),
          "postId": id,
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    }

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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            });
          },
        ),
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Informe o CEP!';
                        }
                        if (value.length != 8) {
                          return 'CEP inválido!';
                        }
                      }),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _cidadeController,
                    decoration: getAuthenticationInputDecoration("Cidade"),
                    validator: (value) => value!.isEmpty
                        ? 'Informe a cidade!'
                        : value.length < 3
                            ? 'Cidade inválida!'
                            : null,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _bairroController,
                    decoration: getAuthenticationInputDecoration("Bairro"),
                    validator: (value) => value!.isEmpty
                        ? 'Informe o bairro!'
                        : value.length < 3
                            ? 'Bairro inválido!'
                            : null,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _ruaController,
                    decoration: getAuthenticationInputDecoration("Rua"),
                    validator: (value) => value!.isEmpty
                        ? 'Informe a rua!'
                        : value.length < 3
                            ? 'Rua inválida!'
                            : null,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: getAuthenticationInputDecoration(
                        "Descreva o problema aqui."),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(),
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor, // Cor de fundo do contêiner
                      borderRadius: BorderRadius.circular(8.0),
                      // Raio da borda para torná-la arredondada
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: const Icon(Icons.attach_file),
                      title: const Text('Anexar foto'),
                      onTap: getImage,
                      trailing:
                          photo != null ? Image.file(File(photo!.path)) : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      uploadData();
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
}
