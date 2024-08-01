// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stepup/app.dart';
import 'package:stepup/data/models/cart_item.dart';
import 'package:stepup/data/models/product_model.dart';
import 'package:stepup/data/providers/favorite_vm.dart';
import 'package:stepup/data/providers/product_vm.dart';
import 'package:stepup/utilities/const.dart';

import '../../widgets/expandable_text.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool isSelected = false;
  int selectedIndex = 0;
  int quantity = 1;
  int size = 40;

  increasePro() {
    quantity++;
    print(quantity);
  }

  decreasetPro() {
    if (quantity == 1) {
      print("quantity $quantity");
    } else {
      quantity--;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    Widget quantityPro() {
      return Row(
        children: [
          IconButton.filled(
            padding: EdgeInsets.zero,
            // constraints: const BoxConstraints(),
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              setState(() {
                decreasetPro();
              });
            },
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 50,
            child: Text(
              textAlign: TextAlign.center,
              quantity.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ),
          IconButton.filled(
            padding: EdgeInsets.zero,
            // constraints: const BoxConstraints(),
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              setState(() {
                increasePro();
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      );
    }

    // Build Page
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết sản phẩm"),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black26),
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20)),
                margin: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset(
                  fit: BoxFit.fitHeight,
                  urlimg + product.img!,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  overflow: TextOverflow.clip,
                                  maxLines: 3,
                                  product.name.toString(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${NumberFormat().format(product.price)} đ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Consumer<FavoriteVm>(
                            builder: (context, myType, child) {
                              final isFavorited =
                                  myType.isProductFavorited(product);
                              return IconButton(
                                iconSize: 35,
                                onPressed: () {
                                  setState(() {
                                    isSelected = !isFavorited;
                                    myType.addFavorite(product);
                                  });
                                },
                                icon: isFavorited
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : Icon(Icons.favorite_border),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kích cỡ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          SingleChildScrollView(
                            child: Container(
                              height: 42,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: product.size!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: InkWell(
                                      customBorder: CircleBorder(),
                                      onTap: () {
                                        setState(
                                          () {
                                            selectedIndex = index;
                                            size = product.size![index];
                                            // print("Size " + size.toString());
                                          },
                                        );
                                      },
                                      child: Ink(
                                        width: 42,
                                        child: Center(
                                          child: Text(
                                            "${product.size![index]}",
                                            style: TextStyle(
                                                color: selectedIndex == index
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          border: selectedIndex == index
                                              ? null
                                              : Border.all(
                                                  color: Colors.black38),
                                          shape: BoxShape.circle,
                                          color: selectedIndex == index
                                              ? Theme.of(context).primaryColor
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Số lượng",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                          quantityPro(),
                        ],
                      ),
                    ),
                  ),
                  Consumer<ProductVMS>(
                    builder: (BuildContext context, ProductVMS value,
                        Widget? child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () {
                                  CartItem cartItem = CartItem(
                                      product: product,
                                      quantity: quantity,
                                      size: size);
                                  print(product.price! * quantity);
                                  value.add(cartItem);

                                  dialogThemGioHang(context);
                                },
                                label: Text('Thêm vào giỏ hàng'),
                                icon: Icon(Icons.add_shopping_cart),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Text(
                    "Thông tin sản phẩm",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  ExpandableText(
                    text: product.des.toString(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Có thắc mắc?",
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                label: Text('Liên hệ hỗ trợ'),
                                icon: Icon(Icons.live_help_outlined),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

dialogThemGioHang(BuildContext context) {
  Dialog errorDialog = Dialog(
//this right here
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Thêm giỏ hàng thành công",
            style: TextStyle(fontSize: 18),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            child: Image.asset(
              width: 100,
              color: Colors.green,
              '${urlimg}cart-check.png',
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 100,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const App(),
                        ),
                        ModalRoute.withName('/homePage'),
                      );
                    },
                    child: Text('Trở về'),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => errorDialog);
}
