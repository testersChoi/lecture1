import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nosepack/common/const/colors.dart';
import 'package:nosepack/common/layout/default_layout.dart';
import 'package:nosepack/common/view/root_tab.dart';

class OrderDoneScreen extends StatelessWidget {
  const OrderDoneScreen({super.key});

  static String get routeName => 'orderDone';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.thumb_up_alt_outlined,
                color: PRIMARY_COLOR,
                size: 50.0,
              ),
              const SizedBox(
                height: 32.0,
              ),
              Text(
                'Payment Completed.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    context.goNamed(RootTab.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  ),
                  child: Text("Go to Home")),
            ]),
      ),
    );
  }
}
