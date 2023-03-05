import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nosepack/common/view/root_tab.dart';
import 'package:nosepack/common/view/splash_screen.dart';
import 'package:nosepack/order/view/order_done_screen.dart';
import 'package:nosepack/restaurant/view/basket_screen.dart';
import 'package:nosepack/restaurant/view/restaurant_detail_screen.dart';
import 'package:nosepack/user/model/user_model.dart';
import 'package:nosepack/user/provider/user_me_provider.dart';
import 'package:nosepack/user/view/login_screen.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        // 'name' CANNOT be duplicated.
        GoRoute(
            path: '/',
            name: RootTab.routeName,
            builder: (_, __) => RootTab(),
            routes: [
              GoRoute(
                path: 'restaurant/:rid',
                name: RestaurantDetailScreen.routeName,
                builder: (_, state) =>
                    RestaurantDetailScreen(id: state.params['rid']!),
              )
            ]),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (_, __) => LoginScreen(),
        ),
        GoRoute(
          path: '/basket',
          name: BasketScreen.routeName,
          builder: (_, __) => BasketScreen(),
        ),
        GoRoute(
          path: '/order_done',
          name: OrderDoneScreen.routeName,
          builder: (_, __) => OrderDoneScreen(),
        ),
      ];

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }

//splash screen
  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logginIn = state.location == '/login';

    if (user == null) {
      return logginIn ? null : '/login';
    }

    // user != null

    // UserModel
    if (user is UserModel) {
      return logginIn || state.location == '/splash' ? '/' : null;
    }

    // usererr
    if (user is UserModelError) {
      return !logginIn ? '/login' : null;
    }

    return null; // go ahead
  }
}
