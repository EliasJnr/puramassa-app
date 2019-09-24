import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:loja_virtual/utils/firebase_notification_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/user_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  MyApp() {
    new FirebaseNotifications().setUpFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: "Atacado Pizza",
              theme: ThemeData(
                  primarySwatch: Colors.yellow, primaryColor: Colors.red),
              home: HomeScreen(),
              debugShowCheckedModeBanner: false,
            ),
          );
        }));
  }
}
