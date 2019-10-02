import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatefulWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _projectVersion = '1.0';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    String projectVersion = '';
    try {
      projectVersion = await GetVersion.projectCode;
    } on PlatformException {
      projectVersion = '1.0';
    }

    setState(() {
      _projectVersion = projectVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "PuraMassa",
                            style: TextStyle(
                                fontSize: 34.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "version: 1.0.$_projectVersion",
                            style: TextStyle(
                                fontSize: 12.0, fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, ${!model.isLoggedIn() ? "" : model.userData['name']}",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn()
                                      ? "Entre ou cadastre-se >"
                                      : "Sair",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  if (!model.isLoggedIn()) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  } else {
                                    model.signOut();
                                  }
                                },
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", widget.pageController, 0),
              DrawerTile(Icons.list, "Produtos", widget.pageController, 1),
              DrawerTile(
                  Icons.location_on, "Contato", widget.pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos",
                  widget.pageController, 3),
            ],
          )
        ],
      ),
    );
  }
}
