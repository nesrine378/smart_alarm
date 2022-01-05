import 'package:flutter/material.dart';


class DialogMessage{
  information(BuildContext context,  String description){
    return showDialog(context: context,
    barrierDismissible: true,
    builder: (BuildContext context){
      return AlertDialog(
        title: Icon(Icons.check_rounded , size: 70.0, color: Colors.green),
        content:  SingleChildScrollView(
          child: ListBody(
            children: [

              Text(description,
              style: TextStyle(fontFamily: 'Pacifico', fontSize: 20.0),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        actions:<Widget> [
          FlatButton(onPressed: (){
            return Navigator.pop(context);
          }, child: Text("OK"),)
        ],
      );
    });
  }
}