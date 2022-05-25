import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final IconData? iconData;
  final String? hintText;
  final bool? isObsecure;
  final bool? enabled;
  const CustomTextField({
    Key? key,
    this.textEditingController,
    this.iconData,
    this.hintText,
    this.isObsecure = true,
    this.enabled = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled,
        controller: textEditingController,
        obscureText: isObsecure!,
        cursorColor: Colors.red[900],
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            iconData,
            color: Colors.blue[900],
          ),
          focusColor: Colors.red[900],
          hintText: hintText,
        ),
      ),
    );
  }
}
