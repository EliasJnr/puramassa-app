import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/order_screen.dart';
import 'package:loja_virtual/tiles/cart_tile.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  final GlobalKey _scaffoldKey;

  CartScreen() : _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
              int p = model.products.length;
              return Text(
                "${p ?? 0} ${p == 1 ? "ITEM" : "ITENS"}",
                style: TextStyle(fontSize: 17.0),
              );
            }),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(builder: (context, child, model) {
        if (model.isLoading && UserModel.of(context).isLoggedIn()) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!UserModel.of(context).isLoggedIn()) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.remove_shopping_cart,
                  size: 80.0,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Faça o login para adicionar produtos!",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 16.0,
                ),
                RaisedButton(
                  child: Text(
                    "Entrar",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                )
              ],
            ),
          );
        } else if (model.products == null || model.products.length == 0) {
          return Center(
            child: Text(
              "Nenhum produto no carrinho!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return ListView(
            children: <Widget>[
              Column(
                children: model.products.map((product) {
                  return CartTile(product);
                }).toList(),
              ),
              DiscountCard(),
              // ShipCard(),
              CartPrice(() async {
                if (model.getProductsPrice() -
                        model.getDiscount() +
                        model.getShipPrice() <
                    30.0) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Valor mínimo por pedido \$30.0 !"),
                    backgroundColor: Colors.redAccent,
                  ));
                } else {
                  _showDialog(model);
                }
              })
            ],
          );
        }
      }),
    );
  }

  void _showDialog(CartModel model) {
    showDialog(
      barrierDismissible: false,
      context: _scaffoldKey.currentContext,
      builder: (BuildContext context) {
        List<TableRow> listRows = List();

        listRows.add(_buildTableRow("ITEM,QTD,TOTAL"));

        model.products
            .map((product) =>
                product.productData.title +
                ", x" +
                product.quantity.toString() +
                ", \$ " +
                product.productData.price.toStringAsFixed(2))
            .forEach((str) {
          listRows.add(_buildTableRow(str));
        });

        if (model.getDiscount() > 0.0)
          listRows.add(_buildTableRow(
              "DESCONTO, x1, \$ " + model.getDiscount().toStringAsFixed(2)));

        listRows.add(_buildTableRow(
            "ENTREGA, x1, \$ " + model.getShipPrice().toStringAsFixed(2)));

        double total = model.getProductsPrice() -
            model.getDiscount() +
            model.getShipPrice();

        listRows
            .add(_buildTableRow("TOTAL, x1, \$ " + total.toStringAsFixed(2)));

        return AlertDialog(
            title: new Center(child: Text("Resumo do Pedido")),
            content: Container(
              width: 600.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Table(
                      border: TableBorder(
                        bottom: BorderSide(
                          color: Theme.of(context).primaryColor,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        right: BorderSide(
                          color: Theme.of(context).primaryColor,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        left: BorderSide(
                          color: Theme.of(context).primaryColor,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        top: BorderSide(
                          color: Theme.of(context).primaryColor,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        horizontalInside: BorderSide(
                          color: Theme.of(context).primaryColor,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                        verticalInside: BorderSide(
                          color: Theme.of(context).primaryColor,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      children: listRows,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MaterialButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          height: 30.0,
                          color: Colors.grey[500],
                          textColor: (Colors.white),
                          child: Text(
                            'VOLTAR',
                            style: TextStyle(fontSize: 15.0, letterSpacing: 1.0),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          splashColor: Colors.grey,
                        ),
                        MaterialButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          height: 30.0,
                          color: Theme.of(context).primaryColor,
                          textColor: (Colors.white),
                          child: Text(
                            'CONFIRMAR',
                            style: TextStyle(fontSize: 15.0, letterSpacing: 1.0),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            String orderId = await model.finishOrder();
                            if (orderId != null)
                              Navigator.of(_scaffoldKey.currentContext)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          OrderScreen(orderId)));
                          },
                          splashColor: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  loadRowsProductsTable(List<String> list) {
    list.forEach((f) {
      return _buildTableRow(f);
    });
  }

  TableRow _buildTableRow(String listOfNames) {
    return TableRow(
      children: listOfNames.split(',').map((name) {
        return Container(
          alignment: Alignment.center,
          child: Text(name,
              style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: name == "TOTAL" ||
                          name == "QTD" ||
                          name == "ITEM" ||
                          name == "ENTREGA" ||
                          name == "DESCONTO"
                      ? FontWeight.bold
                      : FontWeight.normal)),
          padding: EdgeInsets.all(8.0),
        );
      }).toList(),
    );
  }
}
