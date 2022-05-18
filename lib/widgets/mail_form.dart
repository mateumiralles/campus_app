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

  @override
  void dispose() {
    destinatarisController.dispose();
    assumpteController.dispose();
    textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                      controller: destinatarisController,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(fontSize: 16),
                          labelText: 'Introdueix els destinataris!',
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
                          return 'No has introduit destinataris';
                        }
                        return null;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      String newDestinatari = await Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const MailUsersScreen();
                      })) ?? '';
                      setState(() {
                        destinatarisController.text =
                            destinatarisController.text + newDestinatari;
                      });
                    },
                    child: Container(
                        margin: const EdgeInsets.only(left: 20.0),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                        ),
                        child: const Icon(
                          Icons.perm_contact_calendar,
                          size: 30,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: assumpteController,
                decoration: InputDecoration(
                    labelStyle: const TextStyle(fontSize: 16),
                    labelText: "No has introduit l'assumpte!",
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
                    return 'Assumpte necessari';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: textMessageController,
                maxLines: 10,
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
    );
  }
}
