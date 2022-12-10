import 'package:flutter/material.dart';
import 'package:iug/helpers/firestore_helper.dart';
import 'package:iug/models/slide.dart';

class ListSlides with ChangeNotifier {
  final List<Slide> _slidesList = [];

  List<Slide> get pagesList {
    return [..._slidesList];
  }

  Future<List<Slide>> getAllImages() async {
    _slidesList.clear();
    _slidesList
        .addAll(await FireStoreHelper.fireStoreHelper.getSlidesFromFirestore());
    notifyListeners();
    return _slidesList;
  }
}
