// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class CardCity extends StatefulWidget {
  const CardCity({Key? key}) : super(key: key);

  @override
  _CardCityState createState() => _CardCityState();
}

class _CardCityState extends State<CardCity> {
  var isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                print('Card tapped.');
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              child: const SizedBox(
                width: 250,
                height: 150,
                child: Center(child: Text('Da Nang City')),
              ),
            ),
          ),
          Positioned.fill(
            right: 15,
            bottom: 15,
            child: Align(
                alignment: Alignment.bottomRight,
                child: isFavorite == false
                    ? const Icon(Icons.favorite_border)
                    : const Icon(Icons.favorite, color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
