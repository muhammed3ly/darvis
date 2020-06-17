import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Categories with ChangeNotifier {
  List<Map<String, String>> categories;

  void init() async {
    await Firestore.instance
        .collection('/movie categories')
        .getDocuments()
        .then((onValue) {
      categories = onValue.documents.map((f) {
        return {
          'name': f['categoryName'] as String,
          'imageUrl': f['imageUrl'] as String,
          'isFav': f['isFav'] as String,
        };
      }).toList();
      notifyListeners();
    });
  }

  void set(List<Map<String, String>> Rhs) {
    categories = Rhs;
    notifyListeners();
  }
  void clear(){
    categories = null;
    notifyListeners();
  }

  void toggleFavorite(int indx, [bool changeDb = false, String userId]) {
    if (categories[indx]['isFav'] == 'true')
      categories[indx]['isFav'] = 'false';
    else
      categories[indx]['isFav'] = 'true';
    notifyListeners();
    if (changeDb == false) return;
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('categories')
        .document(categories[indx]['name'])
        .updateData({
      'isFav': categories[indx]['isFav'],
    });
  }
}
