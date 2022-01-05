import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/Authentification/LoginPage.dart';
import 'package:app/Models/User.dart';
import '../DialogMessage.dart';
import '../HomePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class SignupPage extends StatefulWidget {

  
  
  State<StatefulWidget> createState() {
    return _LoginRegisterState();
  }

}




class _LoginRegisterState extends State<SignupPage> {
    DialogMessage dialogMessage = new DialogMessage();

  final formKey = new GlobalKey<FormState>();
  User user= User('','');
  


  Future SignUp(String username, String password) async {
        var uri = Uri.parse("http://192.168.56.1:8081/register");

  var res = await http.post(
    uri,
    body: {
      "username": username,
      "password": password
    }
  );
  print(res.statusCode) ;  

  if (res.statusCode == 201) {
    
  } else {
    throw Exception('Failed to create User.');
  }


}

  @override
    Widget build(BuildContext context) {
    return  Scaffold(
        body: Stack (
          children : [
            Positioned(
              top:0 ,
              child: SvgPicture.asset(
                'top1.svg',
                 width:400 ,
                  height:250)),
          Container(
            alignment: Alignment.center,
            child: Form(
           key: formKey,
            child: Column(
              children: [
                SizedBox(height: 100,),
                Text(
                  "Signup",
                  style: GoogleFonts.pacifico(
                    //fontWeight:  FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: 80,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField (
                    controller: TextEditingController(text: user.email),
                    onChanged: (value){
                      user.email = value;
                    } ,
                    validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",

                     decoration: InputDecoration(
                       hintText:'Enter your email' ,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        //borderSide: BorderSide(color: Colors.red)
                         ),
                        
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        //borderSide: BorderSide(color: Colors.red)
                         )),
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField (
                    obscureText: true,
                    controller: TextEditingController(text: user.password),
                    onChanged: (value){
                      user.password = value;
                    } ,


                    validator:(value) => value?.isEmpty?? true ? 'Enter your password' : null,
                   

                     decoration: InputDecoration(
                       hintText:'Enter your Password' ,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Color.fromARGB(255, 187, 187, 171)) ),
                        
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Color.fromARGB(255, 187, 187, 171)) )),
                  ),
                  ),
                  Padding(padding: EdgeInsets.all(16.0),
                  child: Container(
                    height: 50, width: 400,
                    child: FlatButton(
                      color: Color.fromARGB(255, 202, 200, 181) ,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                      onPressed: () async {
                       if(formKey.currentState != null) {
                            formKey.currentState?.validate();
                         if(user.email.length < 4) 
        
                              dialogMessage.information(context, "Invalid Username !! The username should be at least 4 characters long") ;

                            else if(user.password.length < 4) 
                            
                              dialogMessage.information(context, "Invalid Password !! The password should be at least 4 characters long") ;
                            else{
                              var res = await SignUp(user.email, user.password);
                              if(res == 201)
                                dialogMessage.information(context, "Success !! The user was created. Log in now.") ;

                              else if(res == 409)
                                   dialogMessage.information(context,  "That username is already registered ! Please try to sign up using another username or log in if you already have an account.") ;

                              else {
                                 dialogMessage.information(context, "Error !! An unknown error occurred."  ) ;

                              }
                            }
                        print(" register ok");
                      }else {
                        print("register not ok");
                      }
                     
                    },
                    child: Text("Signup", style: GoogleFonts.pacifico( color: Colors.white))) )
                  ,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(65,20,0,0),
                     child : Row(
                    children: [
                     Text("Already  have an account ? ", style: GoogleFonts.pacifico( color: Color.fromARGB(255, 187, 187, 171))),
                     InkWell(
                       onTap:(){
                         Navigator.push(context, new MaterialPageRoute(builder: (context) => LoginPage()));
                       },
                       child: Text("Signin", style: GoogleFonts.pacifico(  fontWeight:  FontWeight.bold, color: Color.fromARGB(255, 146, 31, 16))),
                       )

                     

                    ],
                  )
                  )
                 
              ],
                 
                ),)
                )
          ],
          )
        );
    }
}