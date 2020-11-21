import 'package:farmersapp/Login/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmersapp/Components/data.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong :('),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider<Data>(
            create: (context) => Data(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.dark().copyWith(primaryColor: Colors.white),
              home: SplashScreen(),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
