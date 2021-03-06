import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  PlaceTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
              height: 100.0,
              child: CachedNetworkImage(
                imageUrl: snapshot.data["image"],
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    new Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              )),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.data["title"],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                Text(
                  snapshot.data["address"],
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text("WhatsApp"),
                textColor: Colors.blue,
                padding: EdgeInsets.zero,
                onPressed: () {
                  whatsAppOpen(snapshot.data["phone"], context);
                },
              ),
              FlatButton(
                child: Text("Ligar"),
                textColor: Colors.blue,
                padding: EdgeInsets.zero,
                onPressed: () {
                  launch("tel:${snapshot.data["phone"]}");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void whatsAppOpen(String phone, BuildContext context) async {
    var wppURL = "whatsapp://send?phone=$phone&text=Olá%20quero%20saber%20mais%20!!";
    await canLaunch(wppURL) ? launch(wppURL) : wppNotInstalled(context);
  }

  void wppNotInstalled(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("whatsApp não instalado !"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
