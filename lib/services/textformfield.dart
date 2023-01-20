import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldCard extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final String? validatorText;
  final String labelText;
  final IconData prefixIcon;

  const TextFormFieldCard(
      {Key? key,
      required this.controller,
      required this.enabled,
      required this.keyboardType,
      required this.inputFormatters,
      required this.labelText,
      required this.prefixIcon,
      this.validatorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: enabled,
        cursorColor: const Color(0xFF0a233e),
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorText;
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color(0xFF0a233e),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.0),
              borderSide:
                  const BorderSide(width: 2.0, color: Color(0xFF0a233e))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.0),
              borderSide:
                  const BorderSide(width: 2.0, color: Color(0xFF0a233e))),
          prefixIcon: Icon(
            prefixIcon,
            color: const Color(0xFF0a233e),
          ),
          suffixIcon: IconButton(
            onPressed: () => controller.clear(),
            color: const Color(0xFF0a233e),
            icon: const Icon(Icons.clear),
          ),
        ));
  }
}
