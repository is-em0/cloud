import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iug/models/article.dart';
import 'package:iug/models/slide.dart';

class FireStoreHelper {
  FireStoreHelper._();
  static FireStoreHelper fireStoreHelper = FireStoreHelper._();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // Post section
  Future<void> addPostToFirestore(Article postModal) async {
    await firebaseFirestore
        .collection('Post')
        .doc(postModal.id!.toString())
        .set(postModal.toJson());
  }

  Future<List<Article>> getAllPostsFromFirestore() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firebaseFirestore
        .collection('Post')
        .orderBy('date', descending: true)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = querySnapshot.docs;
    List<Article> posts = docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
            Article.fromJson(e.data()))
        .toList();

    return posts;
  }

  Future<List<Slide>> getSlidesFromFirestore() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection('slide').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = querySnapshot.docs;
    List<Slide> posts = docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
            Slide.fromJson(e.data()))
        .toList();
    return posts;
  }


}
