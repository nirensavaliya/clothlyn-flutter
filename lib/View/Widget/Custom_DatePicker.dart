import 'package:flutter/material.dart';

import '../Constant/App_Colors.dart';
import '../Constant/App_Font.dart';

class CustomDatePicker extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const CustomDatePicker({super.key, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style:  TextStyle(
              fontFamily: FontFamily.hanKenMedium,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF616161),
            ),
            children: const [
              TextSpan(text: " *", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: true,
          cursorColor: AppColors.floatingBtnColor,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: FontFamily.hanKenBold,
          ),
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Date is Required";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "dd / mm / yyyy",
            hintStyle: TextStyle(
              color: Color(0xFF616161),
              fontSize: 16,
              fontFamily: FontFamily.hanKenMedium,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
            border:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
            ),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
            ),
            focusedBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.floatingBtnColor, width: 1.5),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              controller.text =
              "${pickedDate.day.toString().padLeft(2, '0')}/"
                  "${pickedDate.month.toString().padLeft(2, '0')}/"
                  "${pickedDate.year}";
            }
          },
        ),
      ],
    );
  }
}
