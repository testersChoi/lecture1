import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nosepack/common/const/colors.dart';
import 'package:nosepack/common/const/data.dart';
import 'package:nosepack/common/layout/default_layout.dart';
import 'package:nosepack/common/secure_storage/secure_storage.dart';
import 'package:nosepack/common/utils/data_utils.dart';
import 'package:nosepack/common/view/root_tab.dart';
import 'package:nosepack/user/provider/user_me_provider.dart';
import '../../common/component/custom_text_form_field.dart';
import '../model/user_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Title(),
                  const SizedBox(height: 10),
                  _SubTitle(),
                  Image.asset(
                    'asset/img/misc/logo.png',
                    width: MediaQuery.of(context).size.width / 3 * 2,
                  ),
                  CustomTextFormField(
                    hintText: "이메일을 입력해주세요",
                    onChanged: (String value) {
                      username = value;
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextFormField(
                      hintText: "비밀번호를 입력해주세요",
                      obscureText: true,
                      onChanged: (String value) {
                        password = value;
                      }),
                  ElevatedButton(
                      onPressed: state is UserModelLoading
                          ? null
                          : () async {
                              ref.read(userMeProvider.notifier).login(
                                  username: username, password: password);
                            },
                      style: ElevatedButton.styleFrom(
                        primary: PRIMARY_COLOR, //theme을 쓰라는 말인듯.
                      ), // plz on server
                      child: Text("로그인")),
                  TextButton(
                    onPressed: () async {},
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                    child: Text("회원가입"),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "환영합니다",
      style: TextStyle(
        fontSize: 34.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "이메일과 비밀번호를 입력해서 로그인하세요. \n ^^ ",
      style: TextStyle(
        fontSize: 16.0,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
