import 'package:flutter/material.dart';

import '../types.dart';
import '../widgets.dart';

class SetCardView extends StatelessWidget {
  final SetCard card;

  const SetCardView({required this.card});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 2.25 / 3.5,
        child: Card(
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(card.count,
                        (index) => ShapeView(texture: card.texture, shape: card.shape, color: card.color)).toList()))));
  }
}
