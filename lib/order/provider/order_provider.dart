import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/order/model/order_model.dart';
import 'package:nosepack/order/model/post_order_body.dart';
import 'package:nosepack/order/repository/order_repository.dart';
import 'package:nosepack/user/provider/basket_provider.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>((ref) {
  final repo = ref.watch(orderRepositoryProvider);
  return OrderStateNotifier(ref: ref, repository: repo);
});

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository repository;

  OrderStateNotifier({
    required this.ref,
    required this.repository,
  }) : super([]);

  Future<bool> postOrder() async {
    try {
      final uuid = Uuid();
      final id = uuid.v4();

      final state = ref.read(basketProvider);
      final resp = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map((e) => PostOrderBodyProduct(
                    productId: e.product.id,
                    count: e.count,
                  ))
              .toList(),
          totalPrice:
              state.fold<int>(0, (p, n) => p + (n.count * n.product.price)),
          createAt: "",
        ),
      );
      return true;
      // payment btn push => true ? next
    } catch (e) {
      print(e);
      return false;
    }
  }
}
