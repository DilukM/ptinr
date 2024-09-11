import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final String Title;
  late bool selected;
  SettingsButton({
    super.key,
    required this.Title,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                offset: Offset(3, 3),
                blurRadius: 7,
                spreadRadius: 1,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    Title,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: selected
                        ? <Color>[
                            Color.fromARGB(255, 186, 186, 186),
                            Color.fromARGB(255, 233, 233, 233),
                            Color.fromARGB(255, 186, 186, 186),
                          ]
                        : <Color>[
                            Color(0xff52b5b5),
                            Color(0xff20dcdc),
                            Color(0xff52b5b5),
                          ], // Gradient from https://learnui.design/tools/gradient-generator.html
                    tileMode: TileMode.mirror,
                  ),
                ),
                width: 50,
                height: MediaQuery.of(context).size.height,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
