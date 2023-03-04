import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/product/model/product_model.dart';
import 'package:nosepack/user/model/basket_item_model.dart';
import 'package:collection/collection.dart';
import 'package:nosepack/user/model/patch_basket_body.dart';
import 'package:nosepack/user/repository/user_me_repository.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);

  return BasketProvider(
    repository: repository,
  );
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketProvider({required this.repository}) : super([]);

  // op. res
  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                  productId: e.product.id, count: e.count),
            )
            .toList(),
      ),
    );
  }

  final int THIS_IS_NEW_ITEM = 1;
  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 1) if, no items in basket => add
    // 2) items => item count ++
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count + 1) : e,
          )
          .toList();
    } else {
      state = [
        ...state,
        BasketItemModel(product: product, count: THIS_IS_NEW_ITEM),
      ];
    }
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false,
    // count와 상관없이 아예 삭제
  }) async {
    // 1. if exists that product,
    // 1-a. count > 1 => count--
    // 1-b. count == 1 => remove from the basket
    // 2. if not exist, return
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (!exists) {
      return;
    }

    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      state = state
          .where(
            (e) => e.product.id != product.id,
          )
          .toList();
    } else {
      state = state
          .map(
            (e) => e.product.id == product.id
                ? e.copyWith(
                    count: e.count - 1,
                  )
                : e,
          )
          .toList();
    }
    await patchBasket();
  }
}
