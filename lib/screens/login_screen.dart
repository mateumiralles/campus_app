import 'package:campus_app/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, required this.numText, required this.text }) : super(key: key);
   final int numText;
   final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blue,
      body: SafeArea(
          child: GestureDetector(
            onTap: () {FocusScope.of(context).unfocus();},
            child: Column(
                  children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text(
                        '$numText. ',
                        style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(text,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 35,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
             Expanded(flex: 2, child: Center(child: LoginForm(index: numText-1))),
                  ],
                ),
          )),
    );
  }
}
