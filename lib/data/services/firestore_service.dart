import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/favorite_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> addFavorite(FavoriteModel favorite) async {
    await _firestore.collection('favorites').doc(favorite.favoriteId).set(favorite.toMap());
  }

  Future<void> removeFavorite(String favoriteId) async {
    await _firestore.collection('favorites').doc(favoriteId).delete();
  }

  Future<FavoriteModel?> getFavorite(String favoriteId) async {
    final doc = await _firestore.collection('favorites').doc(favoriteId).get();
    if (doc.exists && doc.data() != null) {
      return FavoriteModel.fromMap(doc.data()!);
    }
    return null;
  }

  Stream<QuerySnapshot> getUserFavorites(String userId) {
    return _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
