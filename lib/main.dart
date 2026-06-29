import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/routes/route_generator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoutes,
      initialRoute: AppRoutes.login,
    );
  }
}
