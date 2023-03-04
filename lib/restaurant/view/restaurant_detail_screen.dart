import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nosepack/common/const/colors.dart';
import 'package:nosepack/common/layout/default_layout.dart';
import 'package:nosepack/common/utils/pagination_utils.dart';
import 'package:nosepack/product/component/product_card.dart';
import 'package:nosepack/product/model/product_model.dart';
import 'package:nosepack/rating/component/rating_card.dart';
import 'package:nosepack/restaurant/component/restaurant_card.dart';
import 'package:nosepack/restaurant/model/restaurant_detail_model.dart';
import 'package:nosepack/restaurant/provider/restaurant_provider.dart';
import 'package:nosepack/restaurant/view/basket_screen.dart';
import 'package:nosepack/user/provider/basket_provider.dart';
import 'package:skeletons/skeletons.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../../rating/component/model/rating_model.dart';
import '../../restaurant/provider/restaurant_rating_provider.dart';
import '../model/restaurant_model.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;
  static String get routeName => 'restaurantDetail';
  const RestaurantDetailScreen({required this.id, Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // detailProvider 단순하게 모델만 반환
    //
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantRatingProvider(widget.id).notifier),
    );
    // family...
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));
    final basket = ref.watch(basketProvider);
    if (state == null) {
      return DefaultLayout(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    }
    return DefaultLayout(
        title: "DetailScreen",
        floatingActionButton: FloatingActionButton(
            backgroundColor: PRIMARY_COLOR,
            child: Badge(
              showBadge: basket.isNotEmpty,
              badgeContent: Text(
                basket
                    .fold<int>(
                      0,
                      (previousValue, next) => previousValue + next.count,
                    )
                    .toString(),
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 11.0,
                ),
              ),
              badgeStyle: BadgeStyle(badgeColor: Colors.white),
              child: Icon(Icons.shopping_basket_outlined),
            ),
            onPressed: () {
              context.pushNamed(BasketScreen.routeName);
              // normal, Navi, situation..
              // goNamed -> nesting check: parent page.
            }),
        child: CustomScrollView(
          controller: controller,
          slivers: [
            renderTop(model: state),
            if (state is! RestaurantDetailModel) renderLoading(),
            if (state is RestaurantDetailModel) renderLabel(),
            if (state is RestaurantDetailModel)
              renderProducts(
                products: state.products,
                restaurantModel: state,
              ),
            if (ratingsState is CursorPagination<RatingModel>)
              renderRatings(models: ratingsState.data)
          ],
        ));
  }

  SliverPadding renderRatings({required List<RatingModel> models}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RatingCard.fromModel(model: models[index]),
        ),
        childCount: models.length,
      )),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
          delegate: SliverChildListDelegate(List.generate(
              3,
              (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SkeletonParagraph(
                      style: SkeletonParagraphStyle(lines: 5),
                    ),
                  )))),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantModel model}) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
    required RestaurantModel restaurantModel,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          final model = products[index];
          return InkWell(
            onTap: () {
              ref.read(basketProvider.notifier).addToBasket(
                  product: ProductModel(
                      id: model.id,
                      name: model.name,
                      detail: model.detail,
                      imgUrl: model.imgUrl,
                      price: model.price,
                      restaurant: restaurantModel));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromRestaurantProductModel(
                model: model,
              ),
            ),
          );
        },
        childCount: products.length,
      )),
    );
  }
}
