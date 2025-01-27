import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? title;
  final String? description;
  final String? url;
  final String? id;

  UserModel({this.id,this.title, this.description, this.url});


  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    return UserModel(
      title: snapshot['title'],
      description: snapshot['description'],
      url: snapshot['url'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "title": title,
      "description": description,
      "url": url,
      "id": id,
    };
  }
}
