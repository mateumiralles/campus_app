import 'package:campus_app/citm.dart';
import 'package:campus_app/screens/login_screen.dart';
import 'package:campus_app/screens/main_screen.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key, required this.index, required this.session})
      : super(key: key);
  final int index;
  final Session session;

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  bool credetinalsChecked = false;

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Desactivar el teclat al tocar
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: userController,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 16),
                        labelText: "Introdueix l'usuari",
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
                        return "No has introduit l'usuari";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(fontSize: 16),
                        labelText: "Introdueix la contrasenya",
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
                        return "No has introduit la contrasenya";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: OutlinedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        widget.session.setCredentials(
                            index: widget.index,
                            user: userController.text,
                            pass: passwordController.text);
                        if (widget.index == 0) {
                          credetinalsChecked = await widget.session
                              .checkCitmCredentials(context);
                          if (credetinalsChecked == true) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return LoginScreen(
                                numText: 2,
                                text:
                                    "Inicia sessió amb les credencials d'Atenea",
                                session: widget.session,
                              );
                            }));
                          }
                        } else if (widget.index == 1) {
                          credetinalsChecked = await widget.session
                              .checkAteneaCredentials(context);
                          if (credetinalsChecked == true) {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const MainScreen();
                            }));
                          }
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      primary: Colors.blue,
                      side: const BorderSide(width: 2, color: Colors.blue),
                    ),
                    child: const Text(
                      'CONTINUAR',
                      style: TextStyle(color: Colors.blue),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
