import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  final backgroundColorLogin = Color(0xFF111C28);
  final backgroundColorAllScreens = Color(0xFF121212);
  final appBarBackGroundColor = Color(0xFF13161D);
  final profilePictureCircleColor = Color(0xFF3700B3);
  final style = GoogleFonts.montserrat();
  final List<String> occupation = ['Farmer', 'Vendor'];
  final List<String> cropTypes = [
    'Paddy',
    'Arhar',
    'Bajra',
    'Barley',
    'Copra',
    'Cotton',
    'Sesamum',
    'Gram',
    'Groundnut',
    'Jowar',
    'Maize',
    'Masoor',
    'Moong',
    'Niger',
    'Ragi',
    'Rape',
    'Jute',
    'Safflower',
    'Soyabean',
    'Sugarcane',
    'Sunflower',
    'Urad',
    'Wheat'
  ];
}

class ForSaleItem {
  final String name;
  final String quantity;
  final String photoUrl;
  final String ownerEmail;
  final String ownerRating;
  final String costPer50Kg;
  ForSaleItem({
    this.name,
    this.quantity,
    this.photoUrl,
    this.ownerEmail,
    this.ownerRating,
    this.costPer50Kg,
  });
}
