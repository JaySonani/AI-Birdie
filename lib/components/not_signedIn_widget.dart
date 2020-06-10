  import 'package:aibirdie/constants.dart';
import 'package:flutter/material.dart';
  
  class NotSignedInWidget extends StatelessWidget {
    final String text;

    NotSignedInWidget({this.text});


    @override
    Widget build(BuildContext context) {
      return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Color(0xfff5f5f5),
        boxShadow: [
          BoxShadow(
            offset: Offset(-6.00, -6.00),
            color: Color(0xffffffff).withOpacity(0.80),
            blurRadius: 10,
          ),
          BoxShadow(
            offset: Offset(6.00, 6.00),
            color: Color(0xff000000).withOpacity(0.20),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(15.00),
      ),
      height: MediaQuery.of(context).size.height * 0.3,
      // color: Colors.red,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 40,
              color: softGreen,
            ),
            Column(
              children: <Widget>[
                Text(
                  text,
                  style: level2softdp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    }
  }

