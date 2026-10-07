import 'package:clothlyn/View/Constant/App_Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import '../Constant/App_Font.dart';


class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? suffix;
  final Widget? prefix;
  final int? maxLine;
  final String? hintText;
  final TextAlign? textAlign;
  final double? fontSize;
  final int? maxLength;
  final double? borderRadius;
  final bool isTitle;
  final bool obscureText;
  final bool showCursor;
  final bool readOnly;
  final String? title;
  final TextInputType? textInputType;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final BoxConstraints? prefixIconConstraints;

  const CommonTextField({
    super.key,
    required this.controller,
    this.prefix,
    this.suffix,
    this.maxLine,
    this.hintText,
    this.textAlign,
    this.fontSize,
    this.maxLength,
    this.borderRadius,
    this.isTitle = false,
    this.title,
    this.onTap,
    this.obscureText = false,
    this.showCursor = true,
    this.inputFormatters,
    this.readOnly = false, this.onChanged, this.textInputType,this.validator,this.textInputAction,this.prefixIconConstraints
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(isTitle)
          Text(
            title ?? "",
            style: TextStyle(
              fontFamily: FontFamily.hanKenMedium,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF616161),
            ),
          ),
        if(isTitle)
          Gap(8),
        DecoratedBox(
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(borderRadius ?? 0)
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLine ?? 1,
            textAlign: textAlign ?? TextAlign.start,
            cursorColor: AppColors.accentBrown,
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: fontSize ?? 16,
              fontFamily: FontFamily.hanKenBold,
            ),
            maxLength: maxLength,
            textInputAction: textInputAction ?? TextInputAction.done,
            keyboardType: textInputType ?? TextInputType.text,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            showCursor: showCursor,
            onTap: onTap,
            onChanged: onChanged,
            validator: validator,
            textAlignVertical: suffix != null ? TextAlignVertical.center : null,
            decoration: InputDecoration(

              counter: SizedBox(),
              counterText: '',
              disabledBorder: InputBorder.none,
              border:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
              enabledBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
              ),
              focusedBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
              ),
              // border: InputBorder.none,
              // enabledBorder: InputBorder.none,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.red, width: 1.5),
              ),
              // focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              suffixIcon: suffix,
              prefixIcon: prefix,
              prefixIconConstraints: prefixIconConstraints,
              hintText: hintText ?? "",
              hintStyle: TextStyle(
                color: AppColors.hintTextColor,
                fontSize: 16,
                fontFamily: FontFamily.hanKenMedium,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (newValue.selection.baseOffset < oldValue.selection.baseOffset) {
      return newValue;
    }
    if (text.length == 2 || text.length == 5) {
      if (!text.endsWith('/')) {
        text += '/';
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
