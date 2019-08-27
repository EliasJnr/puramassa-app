import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class MainTab extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("delivery_hours").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {

          print(snapshot.data.documents.first['opened']);
          print(snapshot.data.documents.first['closed']);
          return Row(
            children: <Widget>[
              Container(color: Colors.red,),
              Container(color: Colors.green)
            ],
          );
        }
      },
    );
  }
}
