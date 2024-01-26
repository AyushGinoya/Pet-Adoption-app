import 'package:flutter/material.dart';

class CustomCart {
  Widget cartWidget(
      String pName, String pAge, String pType, String pSubType, String url) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 10, 5),
      child: SizedBox(
        height: 200.0,
        child: Column(
          children: [
            // Text('pet name - , $pName'),
            // Text('pet age - , $pAge'),
            // Text('pet Type - , $pType'),
            // Text('pet subType - , $pSubType'),
          ],
        ),
      ),
    );
  }
}
