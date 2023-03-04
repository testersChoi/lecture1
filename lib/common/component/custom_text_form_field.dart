import 'package:flutter/material.dart';
import 'package:nosepack/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;
  const CustomTextFormField(
      {required this.onChanged,
      this.autoFocus = false,
      this.obscureText = false,
      this.hintText,
      this.errorText,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: INPUT_BORDER_COLOR,
      width: 1.0,
    ));

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText,
      autofocus: autoFocus,
      onChanged: onChanged, //cb
      decoration: InputDecoration(
          errorText: errorText,
          hintText: hintText,
          hintStyle: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
          fillColor: INPUT_BG_COLOR,
          filled: true,
          border: baseBorder,
          enabledBorder: baseBorder,
          focusedBorder: baseBorder.copyWith(
              borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          )),
          contentPadding: EdgeInsets.all(20)),
    );
  }
}
