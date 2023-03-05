import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/common/dio/dio.dart';
import 'package:nosepack/common/model/pagination_params.dart';
import 'package:nosepack/common/repository/base_pagination_repository.dart';
import 'package:nosepack/rating/component/model/rating_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';

part 'restaurant_rating_repository.g.dart';

final restaurantRatingReposioryProvider =
    Provider.family<RestaurantRatingRepository, String>((ref, id) {
  // () 요렇게 한 번 더 싸서 넣는게 콜백스, rid => id값으로 받아서.
  final dio = ref.watch(dioProvider);

  return RestaurantRatingRepository(dio,
      baseUrl: 'http://$ip/restaurant/$id/rating');
});

// family ~ rid ㅈㅣ정
// http://ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository
    implements IBasePaginationRepository<RatingModel> {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET('/') // name is same that is important
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate(
      {@Queries()
          PaginationParams? paginationParams = const PaginationParams()});
}
