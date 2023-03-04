import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nosepack/common/layout/default_layout.dart';
import 'package:nosepack/common/const/data.dart';
import 'package:nosepack/common/secure_storage/secure_storage.dart';
import 'package:nosepack/common/view/root_tab.dart';
import 'package:nosepack/user/view/login_screen.dart';
import '../const/colors.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static String get routeName => 'splash';
  // 로직 단순화 - authprovider ~ 리다이렉트 ~ 유저미에서 다 처리함.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
        backgroundColor: PRIMARY_COLOR,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/img/logo/logo.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
              const SizedBox(
                height: 16.0,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ));
  }
}
