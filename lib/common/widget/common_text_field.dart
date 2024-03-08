import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextFromField extends StatelessWidget {
  final TextEditingController? controller;
  final bool obSecureText;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final Color? color;
  final Color? fontColor;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconButton? suffixIcon;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChange;
  final bool readOnly;
  final Function(dynamic event)? onTapOutSide;

  const CommonTextFromField({
    this.controller,
    this.hintText,
    this.readOnly = false,
    this.onChange,
    this.inputFormatters,
    this.labelText,
    this.validator,
    this.color,
    this.fontColor,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onTapOutSide,
    this.obSecureText = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          readOnly: readOnly,
          obscureText: obSecureText,
          controller: controller,
          validator: validator,
          onChanged: onChange,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: keyboardType,
          onTapOutside: onTapOutSide,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            border: const OutlineInputBorder(),
            prefixIcon: Icon(
              prefixIcon,
              color: color,
            ),
            suffixIcon: suffixIcon,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),),
          ),
          style: TextStyle(
            color: fontColor,
          ),
        ),
      ),
    );
  }
}
