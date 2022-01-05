// class Profile {
//   String username;
//   String CreatedByUsername;
//   String image;
//   Profile(this.username , this.CreatedByUsername ,this.image);

//    factory Profile.fromJson(Map<String, dynamic> json) {
//     username = json['username'];
//     CreatedByUsername = json['CreatedByUsername'];
//     image = json['image'];
//   }

// }




class Profile {



    Profile(this.username , this.CreatedByUsername ,this.image);

  String? username;
  String? CreatedByUsername;
  String? image;

    Profile.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    CreatedByUsername = json['CreatedByUsername'];
    image = json['image'];
  }

 


}

