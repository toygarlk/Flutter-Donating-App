import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'database.dart';
import 'login_page.dart';

class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  State<SellPage> createState() => _SellPageState();
}

GlobalKey<FormState> key = GlobalKey<FormState>();

class _SellPageState extends State<SellPage> {
  String? errorContact;
  TextEditingController titleController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  String imgURL = 'http://icons.iconseeker.com/png/fullsize/vinyl-record-icons/vinyl-red-512.png';
  FirebaseStorage storage = FirebaseStorage.instance;

  uploadImage() async {
    ///Galeriden resim seçme
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    ///Klasör oluşturma
    Reference reference =
        storage.ref().child("images/${DateTime.now().toString()}");

    ///Fotoğraf yükleme
    UploadTask uploadTask = reference.putFile(File(image!.path));

    ///URL İstemcisi
    await (await uploadTask).ref.getDownloadURL().then((value) {
      imgURL = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: navyBlue,
          title: const Text(
            "Bilgileri Doldur",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("asset/bgdnm1.jpg"),
              fit: BoxFit.fitHeight,
              opacity: 0.6,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Form(
                key: key,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 75,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(imgURL),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            uploadImage();
                          },
                          elevation: 20,
                          child: const Text("Resim Seç"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side:
                                const BorderSide(color: Colors.white, width: 4),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        label: Text("Başlık"),
                        prefixIcon: Icon(Icons.mode_edit_outline_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Başlık girmek zorunludur';
                        }
                        return null;
                      },
                      controller: titleController,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        label: Text("Açıklama"),
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Açıklama girmek zorunludur';
                        }
                        return null;
                      },
                      controller: descController,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        label: Text("Sahibinin Adı"),
                        prefixIcon:
                            Icon(Icons.person_outline_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'İsim girmek zorunludur';
                        }
                        return null;
                      },
                      controller: nameController,
                    ),

                     TextFormField(
                       keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        label: Text("Şehir"),
                        prefixIcon:
                            Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şehir ismi girmek zorunludur';
                        }
                        return null;
                      },
                      controller: areaController,
                    ),

                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        label: Text("Stok"),
                        prefixIcon:
                            Icon(Icons.warehouse_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok bilgisi girmek zorunludur';
                        }
                        return null;
                      },
                      controller: priceController,
                    ),

                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      maxLength: 11,
                      decoration: InputDecoration(
                        label: const Text("İletişim Numarası"),
                        prefixIcon: const Icon(Icons.phone),
                        errorText: errorContact,
                      ),
                      onChanged: (val) {
                        setState(() {
                          errorContact = (val.length != 11 || val.isEmpty)
                              ? 'Geçerli Bir Numara Giriniz'
                              : null;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Numara Geçersiz';
                        }
                        return null;
                      },
                      controller: contactController,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: MaterialButton(
                        color: navyBlue,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            MyDatabase.insertData(
                              titleController.text,
                              descController.text,
                              nameController.text,
                              areaController.text,
                              priceController.text,
                              contactController.text,
                              imgURL,
                            );
                            final snackBar = SnackBar(
                              content: const Text(
                                "İlanınız başarıyla listelenmiştir.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              elevation: 10,
                              backgroundColor: navyBlue,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            MyDatabase.selectData().then((value) {
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: const Text(
                          "YAYINLA",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
