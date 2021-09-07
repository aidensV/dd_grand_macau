import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TexfieldRoundedPrefix extends StatelessWidget {
  const TexfieldRoundedPrefix(this.hintText ,this.iconPrefix,this.controller);
  final String hintText;
  final Icon iconPrefix; 
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: (Colors.grey[200])!),
            borderRadius: const BorderRadius.all(
              const Radius.circular(24.0),
            ),
          ),
          prefixIcon: iconPrefix, 
          border: OutlineInputBorder(
            borderSide: BorderSide(color: (Colors.grey[200])!),
            borderRadius: const BorderRadius.all(
              const Radius.circular(24.0),
            ),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
          hintText: hintText,
          fillColor: Colors.grey[200]),
    );
  }
}

class TexfieldRoundedPrefixPassword extends StatelessWidget {
  const TexfieldRoundedPrefixPassword(this.hintText ,this.iconPrefix,this.controller);
  final String hintText;
  final Icon iconPrefix; 
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText:true,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: (Colors.grey[200])!),
            borderRadius: const BorderRadius.all(
              const Radius.circular(24.0),
            ),
          ),
          prefixIcon: iconPrefix, 
          border: OutlineInputBorder(
            borderSide: BorderSide(color: (Colors.grey[200])!),
            borderRadius: const BorderRadius.all(
              const Radius.circular(24.0),
            ),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
          hintText: hintText,
          fillColor: Colors.grey[200]),
    );
  }
}

class TexfieldRoundedPrefixDisabled extends StatelessWidget {
  const TexfieldRoundedPrefixDisabled(this.hintText ,this.iconPrefix,this.controller);
  final String hintText;
  final Icon iconPrefix; 
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: (Colors.grey[200])!),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          prefixIcon: iconPrefix, 
          border: OutlineInputBorder(
            borderSide: BorderSide(color: (Colors.grey[200])!),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
          hintText: hintText,
          fillColor: Colors.grey[200]),
    );
  }
}


class TexfieldPrefix extends StatelessWidget {
  const TexfieldPrefix(this.hintText ,this.iconPrefix,this.controller,
  {this.maxLength = 100,this.typeKeyboard = TextInputType.text,this.obscureText = false });
  final String hintText;
  final Icon iconPrefix; 
  final TextEditingController? controller;
  final int maxLength;
  final TextInputType typeKeyboard;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: typeKeyboard,
      obscureText: obscureText,
        inputFormatters: <TextInputFormatter>[
           
        LengthLimitingTextInputFormatter(maxLength),
    ],
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: (Colors.grey[200])!),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          prefixIcon: iconPrefix, 
        
          
          border: OutlineInputBorder(
            borderSide: BorderSide(color: (Colors.grey[200])!),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            ),
          ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
          hintText: hintText,
          fillColor: Colors.grey[200]),
    );
  }
}
