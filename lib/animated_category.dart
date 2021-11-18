library animated_category;

import 'package:animated_category/suggestion_item.dart';
import 'package:flutter/material.dart';
import 'free_scroll_view.dart';
import 'pr_ext.dart';

class AnimatedCategory<T> extends StatefulWidget {
  final List items;
  final Function itemSelected;
  final double startSize;
  final double deltaSizeFirstTap;
  final double deltaSizeSecondTap;
  final Widget Function(SuggestionItem item, T data) childBuilder;
  final bool setClickedItemDelay;
  final int clickedItemDelay;
  final int itemAnimationDuration;
  final Curve itemCurve;
  final int stackAnimatedDuration;
  final Curve stackCurve;
  final Key key;
  final int columnNumber;
  const AnimatedCategory(
      {Key this.key = const ValueKey(101010),
      required this.childBuilder,
      required this.items,
      required this.itemSelected,
      this.setClickedItemDelay = false,
      this.clickedItemDelay = 100,
      this.startSize = 100.0,
      this.deltaSizeSecondTap = 200.0,
      this.deltaSizeFirstTap = 50.0,
      this.itemAnimationDuration = 400,
      this.itemCurve = Curves.bounceInOut,
      this.stackAnimatedDuration = 600,
      this.columnNumber = 4,
      this.stackCurve = Curves.easeInOutQuint})
      : super(key: key);

  @override
  _AnimatedCategoryState createState() => _AnimatedCategoryState<T>(childBuilder);
}

class _AnimatedCategoryState<T> extends State<AnimatedCategory> with TickerProviderStateMixin {
  Widget Function(SuggestionItem item, T data) childBuilder;
  _AnimatedCategoryState(this.childBuilder);

  Map<int, List<SuggestionItem>> suggestionMatrix = {};

  var needUpdateScrollWidth = true;
  var maxWidth = 0;

  late var startSize;
  late var deltaSize;
  late var deltaSizeBig;

  @override
  void initState() {
    super.initState();

    startSize = widget.startSize;
    deltaSize = widget.deltaSizeFirstTap;
    deltaSizeBig = widget.deltaSizeSecondTap;

    int rowCount = (widget.items.length / widget.columnNumber).round();

    for (int m = 0; m < widget.columnNumber; m++) {
      suggestionMatrix.addAll({m: []});
      print(suggestionMatrix.length);
    }
    suggestionMatrix = Map.from(suggestionMatrix.map((key, value) {
      final endIndex = (rowCount * (key + 1));
      return MapEntry(
          key,
          widget.items
              .getRange(rowCount * key, endIndex < widget.items.length ? endIndex : widget.items.length)
              .toList()
              .asMap()
              .entries
              .map((element) {
            final val = element.value;
            final i = element.key;
            return SuggestionItem(
              widgetKey: UniqueKey(),
              data: val,
              width: startSize,
              height: startSize,
              currentWeight: 1,
              x: (i) * startSize as double,
              y: (key) * startSize as double,
            );
          }).toList());
    }));
    childrenCards(setClickedItemDelay: widget.setClickedItemDelay);
  }

  @override
  Widget build(BuildContext context) {
    updateWidth();
    
    return FreeScrollView(
      child: Container(
        width: maxWidth * startSize as double?,
        height: widget.columnNumber * deltaSizeBig as double?,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.topCenter,
          children: cardsMatrixWidgets.values.toList(),
        )),
    );
  }

  updateWidth() {
    if (needUpdateScrollWidth) {
      needUpdateScrollWidth = false;
      // maxWidth = 0;
      suggestionMatrix.forEach((key, list) {
        final current = list.where((element) => element.currentWeight == 1).length;
        final currentExpand = list.where((element) => element.currentWeight == 2).length;
        final currentExpandMax = list.where((element) => element.currentWeight == 3).length;

        final all = current + (currentExpand * 2) + (currentExpandMax * 2);
        maxWidth = maxWidth < all ? all : maxWidth;
      });
    }
  }

  Map<Key, Widget> cardsMatrixWidgets = {};
  childrenCards({required setClickedItemDelay}) {
    suggestionMatrix.entries.forEach((columns) {
      int iColumn = columns.key;
      List<SuggestionItem> rowsList = columns.value;
      rowsList.asMap().entries.forEach((rows) {
        int iRow = rows.key;
        SuggestionItem currentRow = rows.value;

        currentRow.iColumn = iColumn;
        currentRow.iRow = iRow;

        ///mark: update widgets
        ///
        if (setClickedItemDelay) {
          Future.delayed(Duration(milliseconds: (widget.clickedItemDelay / 100 * currentRow.iRow! * 1.3).round()), () {
            _update(currentRow: currentRow, rowsList: rowsList);
            _updateMatrix(currentRow, rows);
          });
        } else {
          _update(currentRow: currentRow, rowsList: rowsList);

          _updateMatrix(currentRow, rows);
        }
      });
    });
  }

  _updateMatrix(SuggestionItem currentRow, rows) {
    cardsMatrixWidgets[currentRow.widgetKey] = AnimatedPositioned.fromRect(
      // key: currentRow.widgetKey,
      duration: Duration(milliseconds: widget.stackAnimatedDuration),
      curve: widget.stackCurve, //fastOutSlowIn,
      child: item(rows.value, currentRow.widgetKey),
      rect: currentRow.rect,
    );
  }

  _update({required final currentRow, final rowsList}) {
    if (currentRow.iRow > 0) {
      calcOverflowLeft(rowsList.elementAt(currentRow.iRow - 1), currentRow);
    }

    if (currentRow.iColumn > 0) {
      calcOverflowTop(suggestionMatrix[currentRow.iColumn - 1]!.elementAt(currentRow.iRow), currentRow);

      calcOverflowClosestElement(line: suggestionMatrix[currentRow.iColumn - 1]!, current: currentRow);
    }
  }

  bool calcOverflowClosestElement(
      {required List<SuggestionItem> line, required SuggestionItem current, bool check = false}) {
    for (SuggestionItem element in line) {
      if (current.rect.intersect(element.rect).height > 0 && current.rect.intersect(element.rect).width > 0) {
        if (current.rect.intersect(element.rect).height > 0) {
          if (!check) {
            current.y += element.rect.intersect(current.rect).height;
          }
        }
      }
    }
    return false;
  }

  void calcOverflowLeft(SuggestionItem prev, SuggestionItem current, {bool? withGravity}) {
    if (prev.right > current.left) {
      current.x += prev.right - current.left;
    } else if (prev.right < current.left) {
      current.x -= current.left - prev.right;
    }
  }

  void calcOverflowTop(SuggestionItem prev, SuggestionItem current) {
    if (current.x == prev.x) current.y += prev.rect.intersect(current.rect).height;
  }

  Widget item(SuggestionItem e, Key key) {
    return AnimatedContainer(
      key: key,
      duration: Duration(milliseconds: widget.itemAnimationDuration),
      curve: widget.itemCurve,
      height: e.height,
      width: e.width,
      child: Padding(padding: EdgeInsets.all(8), child: childBuilder(e, e.data)).addOnTap(
        onLongPress: () {
          onLongPressItem(e);
          childrenCards(setClickedItemDelay: widget.setClickedItemDelay);
          setState(() {
            needUpdateScrollWidth = true;
          });
        },
        onTap: () {
          onTapItem(e);
          childrenCards(setClickedItemDelay: widget.setClickedItemDelay);
          setState(() {
            needUpdateScrollWidth = true;
          });
        },
      ),
    );
  }

  onTapItem(SuggestionItem e) {
    if (e.currentWeight <= 1) {
      e.currentWeight = e.currentWeight + 1;
      e.height = e.height + deltaSize;
      e.width = e.width + deltaSize;
    } else {
      e.currentWeight = 1;
      e.height = startSize;
      e.width = startSize;
    }
    widget.itemSelected(e);
  }

  onLongPressItem(
    SuggestionItem e,
  ) {
    if (e.currentWeight < 3) {
      e.currentWeight = 3;
      e.height = deltaSizeBig;
      e.width = deltaSizeBig;
    } else {
      e.currentWeight = 1;
      e.height = startSize;
      e.width = startSize;
    }
    widget.itemSelected(e);
  }
}
