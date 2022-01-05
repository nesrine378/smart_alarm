import 'dart:convert';
import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';

import 'Models/Profile.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'dart:async';

import 'package:async/async.dart';

import 'ProfilesFiltredByAdmin.dart';
import 'config.dart';

class AddPersonPage extends StatelessWidget {
  Profile profile = Profile('', '', '');

  @override
  Widget build(BuildContext context) {
    const color = const Color(0xFF880E4F);

    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    String CreatedByUsername = "";

    if (arguments != null) CreatedByUsername = arguments['CurrentUser'];

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 70.0,
          backgroundColor: color,
          title: Text(
            "Add new Profile !",
            style: GoogleFonts.pacifico(fontSize: 20.0),
          ),
        ),
      body: ChangeNotifierProvider<MyProvider>(
        create: (context) => MyProvider(),
        child: Consumer<MyProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: TextEditingController(text: profile.username),
                      onChanged: (value) {
                        profile.username = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'Enter username',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16))),
                    ),
                  ),

// ************************* Get image from gallery *************************
                  if (provider.image != null)
                    Image.network(provider.image.path),

             

                  SizedBox(
                    height: 10.0,
                  ),
                  FloatingActionButton.extended(
                    label: Text('Upload Profile photo'),
                    icon: Icon(Icons.upload_outlined),
                    backgroundColor: color,
                    onPressed: () async {
                      var image = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      provider.setImage(image);
                     
                    },
                  ),

// ******************************* Submit ***************************************
                  // MaterialButton(
                  //   onPressed: () {
                  //     if (provider.image == null) return;
                  //     provider.makePostRequest(profile.username, CreatedByUsername);
                  //   },
                  //   color: color,
                  //   textColor: Colors.white,
                  //   child: Text('make post request...'),
                  // ),

                  SizedBox(
                    height: 10.0,
                  ),

                  IconButton(
          icon: const Icon(Icons.save_sharp),
          tooltip: 'Submit',
          onPressed: () {
                      if (provider.image == null) return;
                      provider.makePostRequest(
                          profile.username, CreatedByUsername);

                            Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilesByUser(),
                                        settings: RouteSettings(
                                    arguments: {
                                      'CurrentUser': CreatedByUsername,
                                    },
                                  ),
                                        
                                      ));
                    },
        ),


                  
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyProvider extends ChangeNotifier {
  var image;

  Future setImage(img) async {
    this.image = img;
    this.notifyListeners();
  }

  Future makePostRequest(username, CreatedByUsername) async {
    String url = db_url+'/upload';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['username'] = username;
    request.fields['CreatedByUsername'] = CreatedByUsername;

    Uint8List data = await this.image.readAsBytes();
    List<int> list = data.cast();
    var stream =
        new http.ByteStream(DelegatingStream.typed(this.image.openRead()));
    var multipartFile = new http.MultipartFile('image', stream, 1000,
        filename: basename(image.path));
    request.files.add(multipartFile);

    var response = await request.send();

    response.stream.bytesToString().asStream().listen((event) {
      var parsedJson = json.decode(event);
      print(parsedJson);
      print(response.statusCode);
    });
  }
}
