import 'package:flutter/material.dart';

LinearGradient appGradient() => LinearGradient(
      colors: [Colors.red[900]!, Colors.blue[900]!, Colors.black],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 0.0),
    );
