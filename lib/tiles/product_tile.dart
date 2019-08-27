import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product){
    this.product.price = double.tryParse(this.product.sizes.first['price'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Card(
          child: type == 'grid'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.8,
                      child: CachedNetworkImage(
                        imageUrl: product.images[0],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            new Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "R\$: ${product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: CachedNetworkImage(
                        imageUrl: product.images[0],
                        fit: BoxFit.cover,
                        height: 250.0,
                        placeholder: (context, url) =>
                            new Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "R\$: ${product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
    );
  }
}
