import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/Models/User.dart';
import '../DialogMessage.dart';
import '../HomePage.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'SignupPage.dart';

class LoginPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _LoginRegisterState();
  }
}

class _LoginRegisterState extends State<LoginPage> {
  DialogMessage dialogMessage = new DialogMessage();
  final formKey = new GlobalKey<FormState>();
  User user = User('', '');

  Future SignIn(String username, String password) async {
    var uri1 = Uri.parse(db_url+"/login");

    var res = await http.post(uri1,
        body: {"username": username, "password": password});
    if (res.statusCode == 200) return res.body;

    return null;
  }

  @override
  Widget build(BuildContext context) {
        const color = const Color(0xFF880E4F);

    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            top: 0,
            child: SvgPicture.asset('./top.svg', width: 400, height: 350)),
        Container(
            alignment: Alignment.center,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    "Signin",
                    style: GoogleFonts.pacifico(
                        //fontWeight:  FontWeight.bold,
                        fontSize: 50,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: TextEditingController(text: user.email),
                      onChanged: (value) {
                        user.email = value;
                      },
                      validator: (value) => EmailValidator.validate(value)
                          ? null
                          : "Please enter a valid email",
                      decoration: InputDecoration(
                          hintText: 'Enter your email',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.blue)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.blue))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: TextEditingController(text: user.password),
                      onChanged: (value) {
                        user.password = value;
                      },
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Enter your password' : null,
                      decoration: InputDecoration(
                          hintText: 'Enter your Password',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 96, 156, 224))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 96, 156, 224)))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                        height: 50,
                        width: 400,
                        child: FlatButton(
                            color: color,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            onPressed: () async {
                              if (formKey.currentState != null) {
                                formKey.currentState?.validate();

                                var jwt =
                                    await SignIn(user.email, user.password);
                                if (jwt != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                        settings: RouteSettings(
                                          arguments: {
                                            'CurrentUser': user.email,
                                          },
                                        ),
                                      ));
                                } else {
                                  dialogMessage.information(context,
                                      "An Error Occurred !! No account was found matching that username and password");
                                }
                              }
                            },
                            child: Text("Signin",
                                style: GoogleFonts.pacifico(
                                    color: Colors.white)))),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(65, 20, 0, 0),
                      child: Row(
                        children: [
                          Text("Don't have an account ? ",
                              style: GoogleFonts.pacifico(
                                color: Color.fromARGB(255, 187, 187, 171),
                              )),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => SignupPage()));
                            },
                            child: Text("Signup",
                                style: GoogleFonts.pacifico(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 146, 31, 16))),
                          )
                        ],
                      ))
                ],
              ),
            ))
      ],
    ));
  }
}
