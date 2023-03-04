import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/common/const/data.dart';
import 'package:nosepack/common/dio/dio.dart';
import 'package:nosepack/common/model/pagination_params.dart';
import 'package:nosepack/common/repository/base_pagination_repository.dart';
import 'package:nosepack/restaurant/model/restaurant_detail_model.dart';
import 'package:nosepack/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/model/cursor_pagination_model.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository =
      RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
  return repository;
});

@RestApi()
abstract class RestaurantRepository
    implements IBasePaginationRepository<RestaurantModel> {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET('/{id}')
  @Headers({'accessToken': 'true'})
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
