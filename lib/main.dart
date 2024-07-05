import 'package:flutter/material.dart';
import 'package:kwizz/models/Category/category_provider.dart';
import 'package:kwizz/Theme/theme_provider.dart';
import 'package:kwizz/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("dark")) prefs.setBool("dark", true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "K w i z z",
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
