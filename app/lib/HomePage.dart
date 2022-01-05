import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/AddProfilePage.dart';

import 'DialogMessage.dart';
import 'ProfilesFiltredByAdmin.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  DialogMessage dialogMessage = DialogMessage();

  @override
  void initState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    String CurentUsername = "";

    if (arguments != null) CurentUsername = arguments['CurrentUser'];

    const color = const Color(0xFF880E4F);
    

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 70.0,
          backgroundColor: color,
          title: Text(
            "Welcome to your Smart Alarm App !",
            style: GoogleFonts.pacifico(fontSize: 20.0),
          ),
        ),

//************************************************************ Button logout *************************************************************************************

        // floatingActionButton: new FloatingActionButton({}
        //   backgroundColor: color,
        //   //onPressed: _logoutUtilisateur,
        //   tooltip: 'logout',
        //   child: new Icon(Icons.west_rounded),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

        //************************************************ Retrieve data from database  ********************************************************************************************
        body: Stack(children: [
          Positioned(
              bottom: 0,
              child: SvgPicture.asset('./top2.svg', width: 400, height: 400)),
          Container(
              child: ListView.builder(
                  itemCount: 1, // the length
                  itemBuilder: (context, index) {
                    // Positioned(
                    //     bottom: 0,
                    //     child: SvgPicture.asset('assets/top2.svg',
                    //         width: 400, height: 300));
                    return Container(
                        child: Column(children: <Widget>[
                      const SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilesByUser(),
                                  settings: RouteSettings(
                                    arguments: {
                                      'CurrentUser': CurentUsername,
                                    },
                                  ),
                                ));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                               ListTile(
                                title: Text('Consult already added members'),
                                subtitle: Text(
                                    'Persons related to you in the database'),
                                trailing:
                                    Icon(Icons.supervised_user_circle_rounded),
                              ),

                              
                            ],
                          ),
                        ),
                      ),
                    
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>AddPersonPage (),
                                  settings: RouteSettings(
                                    arguments: {
                                      'CurrentUser': CurentUsername,
                                    },
                                  ),
                                ));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              ListTile(
                                title: Text('Add new person '),
                                subtitle: Text('Add to the databse'),
                                trailing: Icon(Icons.add_a_photo_rounded),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              
                             
                            ],
                          ),
                        ),
                      ),
                    ]));
                  }))
        ]));
  }
}
