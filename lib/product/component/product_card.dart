import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/common/const/colors.dart';
import 'package:nosepack/restaurant/model/restaurant_detail_model.dart';
import 'package:nosepack/user/provider/basket_provider.dart';

import '../model/product_model.dart';

class ProductCard extends ConsumerWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;
  final String id;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;

  const ProductCard({
    this.onSubtract,
    this.onAdd,
    required this.id,
    required this.price,
    required this.detail,
    required this.name,
    required this.image,
    Key? key,
  }) : super(key: key);

  factory ProductCard.fromProductModel({
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
    required ProductModel model,
  }) {
    return ProductCard(
        id: model.id,
        onAdd: onAdd,
        onSubtract: onSubtract,
        price: model.price,
        detail: model.detail,
        name: model.name,
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ));
  }

  factory ProductCard.fromRestaurantProductModel({
    VoidCallback? onSubtract,
    VoidCallback? onAdd,
    required RestaurantProductModel model,
  }) {
    return ProductCard(
        id: model.id,
        onAdd: onAdd,
        onSubtract: onSubtract,
        price: model.price,
        detail: model.detail,
        name: model.name,
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,
        ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    return Column(
      children: [
        IntrinsicHeight(
          // make widget height max.
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: image,
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // YYN
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500)),
                      Text(detail,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: BODY_TEXT_COLOR,
                            fontSize: 14.0,
                          )),
                      Text('$price',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: PRIMARY_COLOR,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500))
                    ]),
              )
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: _Footer(
              onSubtract: onSubtract!,
              onAdd: onAdd!,
              count: basket
                  .firstWhere((element) => element.product.id == id)
                  .count,
              total: (basket
                          .firstWhere((element) => element.product.id == id)
                          .count *
                      basket
                          .firstWhere((element) => element.product.id == id)
                          .product
                          .price)
                  .toString(),
            ),
          )
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;

  const _Footer({
    required this.onSubtract,
    required this.onAdd,
    required this.count,
    required this.total,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "총 $total won",
            style: TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            renderButton(
              icon: Icons.remove,
              onTap: onSubtract,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              count.toString(),
              style:
                  TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 8.0,
            ),
            renderButton(
              icon: Icons.add,
              onTap: onAdd,
            ),
          ],
        )
      ],
    );
  }

  Widget renderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: PRIMARY_COLOR, width: 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
