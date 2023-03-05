import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/common/provider/pagination_provider.dart';
import 'package:nosepack/product/model/product_model.dart';
import 'package:nosepack/product/repository/product_repository.dart';

import '../../common/model/cursor_pagination_model.dart';

final productProvider =
    StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  final notifier = ProductStateNotifier(repository: repository);
  // instance => paginate()
  return notifier;
});

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({required super.repository});
}
