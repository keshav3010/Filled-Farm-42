import 'package:farmersapp/Components/constants.dart';
import 'package:farmersapp/Components/languages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Data extends ChangeNotifier {
  User user;
  String phoneNumber;
  String currentLanguage = 'en';
  String translatedText;
  Size screenSize;
  String type;
  String occupation;
  String selectedTag;
  String enteredQuantity;
  String enteredAmount;
  String selectedOccupation;
  List<String> tags = [];
  List<ForSaleItem> forSaleItems = [];

  void setQuantity(String _qua) {
    enteredQuantity = _qua;
    notifyListeners();
  }

  void setAmount(String _amo) {
    enteredAmount = _amo;
    notifyListeners();
  }

  void setForSaleItems(List<ForSaleItem> _items) {
    forSaleItems = _items;
    notifyListeners();
  }

  void setSelectedOccupation(String _occ) {
    selectedOccupation = _occ;
    notifyListeners();
  }

  void setSelectedTag(String _tag) {
    selectedTag = _tag;
    notifyListeners();
  }

  void setOccupation(String _occu) {
    occupation = _occu;
    notifyListeners();
  }

  void setTags(List<String> _tags) {
    tags = _tags;
    notifyListeners();
  }

  void setType(String _t) {
    type = _t;
    notifyListeners();
  }

  void setUser(User _currentUser) {
    user = _currentUser ?? null;
  }

  void setPhoneNumber(String _num) {
    phoneNumber = _num;
  }

  void setCurrentLanguage(String _lang) {
    currentLanguage = Languagelist.langs[_lang];
    notifyListeners();
  }
}
