import 'package:flutter/material.dart';
import 'package:hive_sample2/app.dart';
import 'package:hive_sample2/models/note_database.dart';
import 'package:hive_sample2/theme/theme_provider.dart';
import 'package:provider/provider.dart';

extension IntExtension on int? {
  int validate({int value = 0}) {
    return this ?? value;
  }

  Widget get kH => SizedBox(
        height: this?.toDouble(),
      );

  Widget get kW => SizedBox(
        width: this?.toDouble(),
      );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDataBase.initalize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteDataBase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
