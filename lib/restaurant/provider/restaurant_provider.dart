import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/common/model/pagination_params.dart';
import 'package:nosepack/common/provider/pagination_provider.dart';
import 'package:nosepack/restaurant/model/restaurant_model.dart';
import 'package:nosepack/restaurant/repository/restaurant_repository.dart';
import 'package:collection/collection.dart';
import '../../common/model/cursor_pagination_model.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);
  if (state is! CursorPagination) {
    return null;
  }
  //final pState = state as CursorPagination;
  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  // instance => paginate()
  return notifier;
});
// state

//class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });
  // constructor body에 함수를 넣어주면, 클래스가 인스턴스화 되는 순간. 바로 paginate()
  // 리스트들을 넣어놓을 수 있다.

  void getDetail({
    required String id,
  }) async {
    // not CursorPagination, attempt to load data.
    if (state is! CursorPagination) {
      await this.paginate();
    }

    // still, not cursorPagination, just return;
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;
    final resp = await repository.getRestaurantDetail(id: id);

    // [RM1 RM2 RM3...]
    // getDetail(id: 2) req
    // [RM1 'RDM2' RM3]
    // 초기생각 => 이후 생각
    // list.where((e) => e.id == 10)) 데이터 없으면 에러
    // 데이터가 없을 ㄸ/ㅐ는 그냥 캐시의 끝에다가 데이터를 추가한다. RestaurantDetailModel(요청아이디)
    if (pState.data.where((element) => element.id == id).isEmpty) {
      state = pState.copyWith(data: <RestaurantModel>[
        ...pState.data,
        resp,
      ]);
    } else {
      state = pState.copyWith(
          data: pState.data
              .map<RestaurantModel>((e) => e.id == id ? resp : e)
              .toList());
    }
  }
}
