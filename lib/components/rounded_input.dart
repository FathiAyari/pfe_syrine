import 'package:flutter/material.dart';
import 'package:pfe_syrine/components/input_container.dart';
import 'package:pfe_syrine/constants.dart';

class RoundedInput extends StatelessWidget {
  RoundedInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextFormField(
      cursorColor: kPrimaryColor,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(icon: Icon(icon, color: kPrimaryColor), hintText: hint, border: InputBorder.none),
    ));
  }
}

class RoundedPassInput extends StatelessWidget {
  RoundedPassInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.controller,
    required this.ontap,
    required this.isHidden,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final bool isHidden;
  final Function() ontap;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextFormField(
      cursorColor: kPrimaryColor,
      controller: controller,
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
          icon: Icon(icon, color: kPrimaryColor),
          hintText: hint,
          suffixIcon: InkWell(
            onTap: ontap,
            child: Icon(
              isHidden ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          border: InputBorder.none),
    ));
  }
}
