import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/common/model/model_with_id.dart';
import 'package:nosepack/common/repository/base_pagination_repository.dart';
import '../../restaurant/model/restaurant_model.dart';
import '../model/cursor_pagination_model.dart';
import '../model/pagination_params.dart';

class PaginationProvider<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  // <U extends IBasePaginationRepository> same
  final U repository;
  //final IBasePaginationRepository repository;

  PaginationProvider({required this.repository})
      : super(CursorPaginationLoading()) {
    paginate();
  }

  // constructor body에 함수를 넣어주면, 클래스가 인스턴스화 되는 순간. 바로 paginate()
  // 리스트들을 넣어놓을 수 있다.
  Future<void> paginate({
    int fetchCount = 20, // ~paginationCount
    bool fetchMore = false, // false = 새로고침 = 현재상태 덮어씌움
    bool forceRefetch = false, // 강제로 다시 로딩
    // true = CursorPaginationLoading()
  }) async {
    try {
      // return, immediately
      // 1. hasMore = false, 기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면 ㅋ 메타에
      // 2. 로딩중 - fetchMore : true
      //    fetchMore가 아닐 때 : 새로고침의 의도가 있을 수 있다
      if (state is CursorPagination && forceRefetch == false) {
        final pState = state as CursorPagination;

        if (pState.meta.hasMore == false) {
          return;
        }
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;
      // situation2
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      //paginationParams
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore
      if (fetchMore) {
        final pState = (state as CursorPagination<T>);

        state =
            CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);
        paginationParams =
            paginationParams.copyWith(after: pState.data.last.id);
      } else {
        // 만약에 데이터가 있는 상황이라면 기존 데이터를 보존한 채로 페치-에이피아이 요청을 진행
        if (state is CursorPagination &&
            !forceRefetch) //forceRefetch 처음부터 == 아무것도 없는 로딩 필요
        {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
              data: pState.data, meta: pState.meta);
        } else {
          state = CursorPaginationLoading();
        }
      }
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      ); // initial cuz no after value

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;
        // before + new
        state = resp.copyWith(
            // meta == meta,
            data: [
              ...pState.data, // ㄱㅣ존
              ...resp.data, // +20
            ]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: 'no data');
    }
  }

  // void getDetail({
  //   required String id,
  // }) async {
  //   // not CursorPagination, attempt to load data.
  //   if (state is! CursorPagination) {
  //     await this.paginate();
  //   }

  //   // still, not cursorPagination, just return;
  //   if (state is! CursorPagination) {
  //     return;
  //   }

  //   final pState = state as CursorPagination;

  //   // [RM1 RM2 RM3...]
  //   // getDetail(id: 2) req
  //   // [RM1 'RDM2' RM3]
  //   final resp = await repository.getRestaurantDetail(id: id);
  //   state = pState.copyWith(
  //       data: pState.data
  //           .map<RestaurantModel>((e) => e.id == id ? resp : e)
  //           .toList());
  // }
}
