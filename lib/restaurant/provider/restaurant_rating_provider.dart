import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/common/provider/pagination_provider.dart';
import 'package:nosepack/rating/component/model/rating_model.dart';
import 'package:nosepack/restaurant/repository/restaurant_rating_repository.dart';

import '../../common/model/cursor_pagination_model.dart';

final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingStateNotifier, CursorPaginationBase, String>((ref, id) {
  final repo = ref.watch(restaurantRatingReposioryProvider(id));

  return RestaurantRatingStateNotifier(repository: repo);
});

class RestaurantRatingStateNotifier
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingStateNotifier({required super.repository});
}
