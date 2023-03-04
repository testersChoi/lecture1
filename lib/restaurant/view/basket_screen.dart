import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nosepack/common/const/colors.dart';
import 'package:nosepack/common/layout/default_layout.dart';
import 'package:nosepack/order/provider/order_provider.dart';
import 'package:nosepack/order/view/order_done_screen.dart';
import 'package:nosepack/product/component/product_card.dart';
import 'package:nosepack/user/provider/basket_provider.dart';

class BasketScreen extends ConsumerWidget {
  static String get routeName => 'basket';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    if (basket.isEmpty) {
      return DefaultLayout(
        title: "BASKET",
        child: Center(
          child: Text(
            "EMPTY",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final productsTotal = basket.fold<int>(
      0,
      (p, n) => p + (n.product.price * n.count),
    );
    final deliveryFee = basket.first.product.restaurant.deliveryFee;

    return DefaultLayout(
      title: "Basket",
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, index) {
                    return const Divider(
                      height: 32.0,
                    );
                  },
                  itemCount: basket.length,
                  itemBuilder: (_, index) {
                    final model = basket[index];

                    return ProductCard.fromProductModel(
                      model: model.product,
                      onAdd: () {
                        ref
                            .read(basketProvider.notifier)
                            .addToBasket(product: model.product);
                      },
                      onSubtract: () {
                        ref
                            .read(basketProvider.notifier)
                            .removeFromBasket(product: model.product);
                      },
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "basket all",
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      Text(
                        basket
                                .fold<int>(0,
                                    (p, n) => p + (n.product.price * n.count))
                                .toString() +
                            " won",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "delivery fee",
                        style: TextStyle(color: BODY_TEXT_COLOR),
                      ),
                      if (basket.length > 0)
                        Text(basket.first.product.restaurant.deliveryFee
                                .toString() +
                            " won"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "overall",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text((productsTotal + deliveryFee).toString() + " won"),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final resp =
                            await ref.read(orderProvider.notifier).postOrder();
                        if (resp) {
                          context.goNamed(OrderDoneScreen.routeName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("failed in payment")));
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                      child: Text("Payment"),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
