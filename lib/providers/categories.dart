import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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

  List<Map<String, dynamic>> get favs {
    List<Map<String, dynamic>> ret = [];
    for (int i = 0; i < categories.length; i++) {
      if (categories[i]['isFav'] == 'true') {
        ret.add(
          {
            'index': i,
            'name': categories[i]['name'],
          },
        );
      }
    }
    return ret;
  }

  void set(List<Map<String, String>> Rhs) {
    categories = Rhs;
    notifyListeners();
  }

  void clear() {
    categories = null;
    notifyListeners();
  }

  void toggleFavorite(int indx, [bool changeDb = false, String userId]) async {
    if (categories[indx]['isFav'] == 'true')
      categories[indx]['isFav'] = 'false';
    else
      categories[indx]['isFav'] = 'true';
    notifyListeners();
    if (changeDb == false) return;
    try {
      await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('categories')
          .document(categories[indx]['name'])
          .updateData({
        'isFav': categories[indx]['isFav'],
      });
    } on PlatformException {
      if (categories[indx]['isFav'] == 'true')
        categories[indx]['isFav'] = 'false';
      else
        categories[indx]['isFav'] = 'true';
      notifyListeners();
      showError(
        'Couldn\'t toggle this movie preference',
        'Please check your internet connection.',
      );
    } catch (error) {
      if (categories[indx]['isFav'] == 'true')
        categories[indx]['isFav'] = 'false';
      else
        categories[indx]['isFav'] = 'true';
      notifyListeners();
      showError(
        'Couldn\'t toggle this movie preference',
        'Please check your internet connection.',
      );
    }
  }

  void showError(String title, String message) {
    Get.rawSnackbar(
      titleText: title ??
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red[700],
    );
  }
}
