import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Padding subscriptionCard(BuildContext context, String title, String content,
    String cost, String range) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Card(
      color: Color.fromARGB(255, 220, 249, 246),
      elevation: 6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Color(0xff52b5b5),
                    Color(0xff20dcdc),
                    Color(0xff52b5b5),
                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                  tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            padding: const EdgeInsets.all(2),
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Text(
                    content,
                    maxLines: null,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      "$cost USD",
                      style: const TextStyle(
                          fontSize: 25,
                          color: Color(0xff52b5b5),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      "per $range",
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff52b5b5),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
