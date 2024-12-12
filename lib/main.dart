import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stockly/Screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:stockly/services/auth.dart';
import 'package:stockly/models/user_model.dart';
import 'package:stockly/firebase_options.dart';
import 'package:stockly/Screens/stock screen/newsfeed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Pass Firebase options
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Our_User?>.value(
      initialData: null,
      catchError: (context, error) => null, // Corrected error handling
      value: AuthService().user,
      child: MaterialApp(
        title: 'Stockly',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.black87,
        ),
        home: const Wrapper(), // Wrapper will decide where to navigate
        routes: {
          '/newsfeed': (context) => const NewsFeedScreen(myStockSymbols: [],), // Added NewsFeed route
        },
      ),
    );
  }
}