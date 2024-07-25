import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stepup/data/models/cart_item.dart';
import 'package:stepup/data/models/product_model.dart';
import 'package:stepup/data/providers/favorite_vm.dart';
import 'package:stepup/data/providers/product_vm.dart';
import 'package:stepup/utilities/const.dart';

class GridItem extends StatefulWidget {
  const GridItem({super.key, required this.product});

  final Product product;

  @override
  State<StatefulWidget> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<FavoriteVm, ProductVM>(
      builder: (context, favorite, cart, child) {
        CartItem cartItem = CartItem(product: widget.product, quantity: 1);
        bool isFavorited = favorite.isProductFavorited(widget.product);
        return Card.outlined(
          elevation: 8,
          surfaceTintColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              "/productDetail",
              arguments: widget.product,
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 36),
                      // color: Colors.grey[200],
                      child: Image.asset(
                        height: 120,
                        width: double.infinity,
                        urlimg + widget.product.img!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                          child: Icon(Icons.hide_image_outlined),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.product.name!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(widget.product.brand!),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              '${NumberFormat('###,###.###').format(widget.product.price!)}đ',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Material(
                    elevation: 18,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: MaterialButton(
                      onPressed: () {
                        cart.add(cartItem);
                      },
                      color: Theme.of(context).primaryColor,
                      minWidth: 48,
                      height: 48,
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          favorite.addFavorite(widget.product);
                          isFavorited =
                              favorite.isProductFavorited(widget.product);
                        },
                      );
                    },
                    icon: isFavorited
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_border),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
