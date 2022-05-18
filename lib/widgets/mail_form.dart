import 'package:campus_app/screens/mail_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/citm.dart';

class MailForm extends StatefulWidget {
  const MailForm({Key? key}) : super(key: key);

  @override
  MailFormState createState() {
    return MailFormState();
  }
}

class MailFormState extends State<MailForm> {
  final _formKey = GlobalKey<FormState>();

  var destinatarisController = TextEditingController();
  final assumpteController = TextEditingController();
  final textMessageController = TextEditingController();

  bool scrollBool = false;

  @override
  void dispose() {
    destinatarisController.dispose();
    assumpteController.dispose();
    textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Desactivar el teclat al tocar
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          scrollBool = false;
        });
      },
      child: SingleChildScrollView(
        reverse: scrollBool,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              scrollBool = false;
                            });
                          },
                          controller: destinatarisController,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(fontSize: 16),
                              labelText: 'Introdueix els destinataris!',
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Colors.blue),
                                borderRadius: BorderRadius.circular(15),
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'No has introduit destinataris';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: IconButton(
                            onPressed: () async {
                              String newDestinatari =
                                  await Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return const MailUsersScreen();
                                      })) ??
                                      '';
                              setState(() {
                                destinatarisController.text =
                                    destinatarisController.text +
                                        newDestinatari;
                              });
                            },
                            splashRadius: 27,
                            color: Colors.blue,
                            splashColor: Colors.blue[100],
                            iconSize: 40,
                            icon: const Icon(
                              Icons.person_add_rounded,
                              color: Colors.blue,
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    onTap: () {
                      setState(() {
                        scrollBool = false;
                      });
                    },
                    controller: assumpteController,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 16),
                        labelText: "Introdueix l'assumpte",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "No has introduit l'assumpte!";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    onTap: () {
                      setState(() {
                        scrollBool = true;
                      });
                    },
                    controller: textMessageController,
                    maxLines: 12,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 16),
                        labelText: "Escriu el missatge!",
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        CITM.sendMsg(
                            destinataris: destinatarisController.text,
                            assumpte: assumpteController.text,
                            text: textMessageController.text,
                            context: context);
                      }
                    },
                    child: const Text('Enviar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
