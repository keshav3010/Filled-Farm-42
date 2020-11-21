import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  final backgroundColorLogin = Color(0xFF111C28);
  final backgroundColorAllScreens = Color(0xFF121212);
  final appBarBackGroundColor = Color(0xFF13161D);
  final profilePictureCircleColor = Colors.blueAccent; //Color(0xFF3700B3);
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

class SoldItems {
  final String ownerName;
  final String vendorName;
  final String tag;
  final String quantity;
  final String city;
  final String rating;
  final String photoUrl;
  final String ownerEmail;
  final String vendorEmail;
  final String ownerRating;
  final String costPer50Kg;
  final String organization;
  SoldItems({
    this.ownerName,
    this.vendorName,
    this.tag,
    this.quantity,
    this.city,
    this.photoUrl,
    this.ownerEmail,
    this.vendorEmail,
    this.ownerRating,
    this.costPer50Kg,
    this.organization,
    this.rating
  });
}

class ForSaleItem {
  final String ownerName;
  final String tag;
  final String quantity;
  final String city;
  final String photoUrl;
  final String ownerEmail;
  final String ownerRating;
  final String costPer50Kg;
  ForSaleItem({
    this.ownerName,
    this.tag,
    this.quantity,
    this.city,
    this.photoUrl,
    this.ownerEmail,
    this.ownerRating,
    this.costPer50Kg,
  });
}
