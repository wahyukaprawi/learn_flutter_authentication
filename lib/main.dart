import 'package:flutter/material.dart';
import 'package:learn_flutter_authentication/pages/auth_page.dart';
import 'package:learn_flutter_authentication/providers/authentication.dart';
import 'package:learn_flutter_authentication/providers/product.dart';
import 'package:provider/provider.dart';

import './pages/add_product_page.dart';
import './pages/edit_product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Authentication(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        routes: {
          AddProductPage.route: (ctx) => AddProductPage(),
          EditProductPage.route: (ctx) => const EditProductPage(),
        },
      ),
    );
  }
}
