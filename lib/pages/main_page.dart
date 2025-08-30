import 'package:flutter/material.dart';
import '../types.dart';
import '../widgets.dart';

class SetHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SetHomeState();
}

class SetHomeState extends State<SetHome> {
  final List<List<SetCard>> cardGrid = [];
  @override
  void initState() {
    super.initState();

    List<SetCard> deck = newDeck();
    deck.shuffle();
    List<List<SetCard>> results = [];
    getNonOverlappingSets([], 4, deck, results);
    List<SetCard> cards = results.expand((c) => c).toList();
    cards.shuffle();

    for (int y = 0; y < 4; y++) {
      List<SetCard> row = [];
      for (int c = 0; c < 3; c++) {
        row.add(cards.removeLast());
      }
      cardGrid.add(row);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [];
    for (List<SetCard> row in cardGrid) {
      List<Widget> rowChildren = [];
      for (SetCard card in row) {
        rowChildren.add(Expanded(
          child: Padding(padding: EdgeInsets.all(8), child: SetCardView(card: card)),
        ));
      }
      columnChildren.add(Row(
        children: rowChildren,
      ));
    }
    return Scaffold(
        backgroundColor: Colors.purple.shade50,
        body: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: columnChildren)));
  }

  List<SetCard> newDeck() {
    List<SetCard> cards = [];
    for (ShapeType shape in ShapeType.values) {
      for (TextureType tex in TextureType.values) {
        for (ColorType clr in ColorType.values) {
          for (int count = 1; count <= 3; count++) {
            cards.add(SetCard(tex, shape, clr, count));
          }
        }
      }
    }
    return cards;
  }

  void getNonOverlappingSets(
    List<SetCard> currentSet, int desiredSets, List<SetCard> allCards, List<List<SetCard>> results) {
    if (results.length == desiredSets) {
      return;
    }
    for (SetCard card in allCards) {
      if (!currentSet.contains(card)) {
        List<SetCard> potentialSet = currentSet + [card];
        if (potentialSet.length == 3) {
          if (isSet(potentialSet) && !doSetsOverlap(results, potentialSet)) {
            results.add(potentialSet);
          }
        } else {
          getNonOverlappingSets(potentialSet, desiredSets, allCards, results);
        }
      }
    }
  }

  bool isSet(List<SetCard> cards) {
    if (cards.length != 3) {
      return false;
    }
    Set<ShapeType> shape = Set<ShapeType>();
    Set<TextureType> textures = Set<TextureType>();
    Set<ColorType> colors = Set<ColorType>();
    Set<int> counts = Set<int>();
    for (SetCard c in cards) {
      shape.add(c.shape);
      textures.add(c.texture);
      colors.add(c.color);
      counts.add(c.count);
    }
    return (shape.length == 1 || shape.length == 3) &&
        (textures.length == 1 || textures.length == 3) &&
        (colors.length == 1 || colors.length == 3) &&
        (counts.length == 1 || counts.length == 3);
  }

  bool doSetsOverlap(List<List<SetCard>> sets, List<SetCard> candidateSet) {
    List<SetCard> allCards = sets.expand((c) => c).toList() + candidateSet;
    List<List<SetCard>> possibleSets = [];
    getAllSets(0, [], allCards, possibleSets);
    return !(possibleSets.length == sets.length + 1);
  }

  void getAllSets(int idx, List<SetCard> currentSet, List<SetCard> cards, List<List<SetCard>> allSets) {
    for (int i = idx; i < cards.length; i++) {
      List<SetCard> potentialSet = currentSet + [cards[i]];
      if (potentialSet.length == 3) {
        if (isSet(potentialSet)) {
          allSets.add(potentialSet);
        }
      } else {
        getAllSets(i + 1, potentialSet, cards, allSets);
      }
    }
  }
}
