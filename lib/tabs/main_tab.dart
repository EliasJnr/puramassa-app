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
          bool opened = false;

          DateTime startDelivery =
              snapshot.data.documents.first['opened'].toDate();
          DateTime stopDelivery =
              snapshot.data.documents.first['closed'].toDate();

          if (startDelivery.hour <= DateTime.now().hour) {
            opened = true;
          } else {
            opened = false;
          }

          String openedHour = startDelivery.hour.toString() +
              ":" +
              startDelivery.minute.toStringAsFixed(1);

          String hour = stopDelivery.hour.toStringAsFixed(1) +
              ":" +
              stopDelivery.minute.toStringAsFixed(1);

          return Center(
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ExpansionTile(
                    backgroundColor: Colors.transparent,
                    title: Text(
                      opened
                          ? "Aberto até " + hour.replaceAll(".", "") + "h"
                          : "Abre às " + openedHour.replaceAll(".", "") + "h",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: opened ? Colors.grey[700] : Colors.red),
                    ),
                    leading: Icon(Icons.access_time),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 4.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color: !opened
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).accentColor)),
                          child: TextFormField(
                            decoration: InputDecoration(),
                            initialValue: " Delivery: " +
                                openedHour.replaceAll(".", "") +
                                "h" +
                                " às " +
                                hour.replaceAll(".", "") +
                                "h",
                            enabled: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
