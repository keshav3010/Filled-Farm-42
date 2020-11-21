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
  String type;
  String occupation;
  String selectedTag;
  String enteredQuantity;
  String enteredAmount;
  String selectedOccupation;
  String rating;
  String currentCity;
  String reviewers;
  String organization;
  bool loggedAndLoaded = false;

  List<String> tags = [];
  List<ForSaleItem> forSaleItems = [];
  List<SoldItems> soldItems = [];

  void setSoldItems(List<SoldItems> _si) {
    soldItems = _si;
    notifyListeners();
  }

  void setOrganization(String _org) {
    organization = _org;
    notifyListeners();
  }

  void setCity(String _c) {
    currentCity = _c;
    notifyListeners();
  }

  void setLoggedAndLoaded(bool _stat) {
    loggedAndLoaded = _stat;
    notifyListeners();
  }

  void setRating(String _ra) {
    rating = _ra;
    notifyListeners();
  }

  void setReviewers(String _re) {
    reviewers = _re;
    notifyListeners();
  }

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

  void setEverythingToNull() {
    user = null;
    phoneNumber = null;
    currentLanguage = null;
    translatedText = null;
    type = null;
    occupation = null;
    selectedTag = null;
    enteredQuantity = null;
    enteredAmount = null;
    selectedOccupation = null;
    rating = null;
    currentCity = null;
    reviewers = null;
    organization = null;
    loggedAndLoaded = null;
  }
}
