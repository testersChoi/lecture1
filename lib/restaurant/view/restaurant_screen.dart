import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nosepack/common/component/pagination_list_view.dart';
import 'package:nosepack/common/utils/pagination_utils.dart';
import 'package:nosepack/restaurant/view/restaurant_detail_screen.dart';
import '../component/restaurant_card.dart';
import '../provider/restaurant_provider.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();
  final int shouldFetchMorePixel = 300;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantProvider.notifier),
    );
    // 90% 리스트 왔을 때 새로운 데이터 요청
    // if (controller.offset >
    //     controller.position.maxScrollExtent - shouldFetchMorePixel) {
    //   ref.read(restaurantProvider.notifier).paginate(
    //         fetchMore: true,
    //       );
    // }
  }

  //Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
  @override
  Widget build(BuildContext context) {
    return PaginationListView(
        provider: restaurantProvider,
        itemBuilder: <RestaurantModel>(_, index, model) {
          return GestureDetector(
              onTap: () {
                context.goNamed(RestaurantDetailScreen.routeName,
                    params: {'rid': model.id});
              },
              child: RestaurantCard.fromModel(model: model));
        });
  }
}
