import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'DialogMessage.dart';
import 'Models/Profile.dart';

import 'dart:async';

import 'config.dart';




class ProfilesByUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilesByUserState();
  }
}

class _ProfilesByUserState extends State<ProfilesByUser> {
  //List<PostProfilesByUsers> postsGuestHouse = [];
  DialogMessage dialogMessage = new DialogMessage();

  

  Future<List<Profile>> GetprofilesByUser(String CurentUsername)  async {
    var uri1 = Uri.parse(db_url+"/getprofile/${CurentUsername}");

    var res = await http.get(uri1);
        List<Profile> _loadAds = [];

    if (res.statusCode == 200) 
    {

      final parsed = jsonDecode(res.body);
  
     for (var i = 0; i < parsed["profile"].length; i++) {
        Map<String, dynamic> map = parsed["profile"][i];
        _loadAds.add(Profile.fromJson(map));
       
      }

   }
  return _loadAds;
  
  }





@override
  void initState() {
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    String CurentUsername = "";

    if (arguments != null) CurentUsername = arguments['CurrentUser'];

GetprofilesByUser(CurentUsername);
    const color = const Color(0xFF880E4F);
 

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 70.0,
          backgroundColor: color,
          title: Text(
            "Profiles already added by you !",
            style: GoogleFonts.pacifico(fontSize: 20.0),
          ),
        ),

        //************************************************ Retrieve data from database  ********************************************************************************************
        body : FutureBuilder< List<Profile>>(
          future: GetprofilesByUser(CurentUsername),
          builder: (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
            if (!snapshot.hasData) {
              // while data is loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else{
              var profiles = snapshot.data;
              return  ListView.builder(
              itemCount: profiles?.length,
              itemBuilder: (_, index) {
                return ProfileUI(
                  profiles![index],
                );
              });
            }
          }
  
        )
        
        );
  }

  Widget ProfileUI(Profile profile)  {

    const color = const Color(0xFF880E4F);
String? profilephoto= profile.image.toString().substring(14);
//String? profilephoto = photo.toString().replaceAll(new RegExp(r"[^\w.]") , '/');
    return GestureDetector( 
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(width: 1, color: Colors.grey)
          ),

          child:  Container(
            padding:  EdgeInsets.all(14.0),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                 Text(
                   profile.username.toString(),
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pacifico',
                    color: color,
                  ),
                ),
                
                Image.network(db_url+"/"+profilephoto),

                const SizedBox(
                  height: 10.0,
                ),

               IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'delete',
          onPressed: () {
           
          },
        ),


              ],
            ),
          ),
        ),

        
      );
  }





}
