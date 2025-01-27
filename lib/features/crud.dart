import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/features/image_process.dart';
import 'package:notes/model/model.dart';

class DataService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createData(UserModel userModel) {

    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    final userCollection = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes');

    // final userCollection = FirebaseFirestore.instance.collection("notes");

    String id = userCollection.doc().id;

    final newData = UserModel(
      title: userModel.title,
      description: userModel.description,
      url: userModel.url,
      id: id,
    ).toJson();

    userCollection.doc(id).set(newData);
  }

  Future<List<Map<String, dynamic>>> readData() async {

    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    CollectionReference collectionRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes');

    // CollectionReference collectionRef = FirebaseFirestore.instance.collection('notes');
    QuerySnapshot querySnapshot = await collectionRef.get();

    List<Map<String, dynamic>> fetchedData = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> documentData = doc.data() as Map<String, dynamic>;
      fetchedData.add(documentData);
    }

    return fetchedData;
  }

  void updateData(UserModel userModel) {

    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    // final userCollection = FirebaseFirestore.instance.collection("notes");
    final userCollection = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes');

    final newData = UserModel(
      title: userModel.title,
      description: userModel.description,
      url: userModel.url,
      id: userModel.id,
    ).toJson();

    userCollection.doc(userModel.id).update(newData);
  }

  Future<void> deleteData(String id) async {

    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    // final userCollection = FirebaseFirestore.instance.collection("notes");

    final userCollection = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes');

    // userCollection.doc(id).delete();
    DocumentSnapshot docSnapshot = await userCollection.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> noteData = docSnapshot.data() as Map<String, dynamic>;
      String imageUrl = noteData['url'];
      await deleteImage(imageUrl); // Call deleteImage method to delete the image
      await userCollection.doc(id).delete();
    }
  }

  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    // Delete all user data
    final userCollection = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes');

    QuerySnapshot querySnapshot = await userCollection.get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> noteData = doc.data() as Map<String, dynamic>;
      String imageUrl = noteData['url'];
      await deleteImage(imageUrl);
      await doc.reference.delete();
    }

    // Delete user document
    await _firestore.collection('users').doc(user.uid).delete();

    // Delete user account
    await user.delete();
  }

}