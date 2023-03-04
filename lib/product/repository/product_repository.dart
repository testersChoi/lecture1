import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/common/dio/dio.dart';
import 'package:nosepack/common/model/pagination_params.dart';
import 'package:nosepack/common/repository/base_pagination_repository.dart';
import 'package:nosepack/product/model/product_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';

part 'product_repository.g.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProductRepository(dio, baseUrl: "http://$ip/product");
});

//http://$ip/product
@RestApi()
abstract class ProductRepository
    implements IBasePaginationRepository<ProductModel> {
  factory ProductRepository(Dio dio, {String baseUrl}) = _ProductRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<ProductModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
