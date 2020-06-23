import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Categories with ChangeNotifier {
  List<Map<String, String>> categories;

  Future<bool> init() async {
    if (categories != null) return true;
    Firestore.instance
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
    return true;
  }

  Future<void> set(List<Map<String, String>> Rhs) async {
    categories = Rhs;
  }

  void clear() {
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
