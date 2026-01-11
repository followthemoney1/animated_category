library animated_category;

import 'package:animated_category/suggestion_item.dart';
import 'package:flutter/material.dart';
import 'free_scroll_view.dart';
import 'pr_ext.dart';

class AnimatedCategory<T> extends StatefulWidget {
  final List items;

  final Function(SuggestionItem e)? itemSelected;

  final double startSize;

  final double deltaSizeFirstTap;

  final double deltaSizeSecondTap;

  final int? clickedItemDelay;

  final int itemAnimationDuration;

  final Curve itemCurve;

  final int stackAnimatedDuration;

  final Curve stackCurve;

  final Key key;

  final int columnNumber;

  final Widget Function(SuggestionItem item, T data) childBuilder;

  ///
  const AnimatedCategory({
    required this.childBuilder,
    required this.items,
    this.itemSelected,
    this.key = const ValueKey(101010),
    this.clickedItemDelay,
    this.startSize = 100.0,
    this.deltaSizeSecondTap = 200.0,
    this.deltaSizeFirstTap = 50.0,
    this.itemAnimationDuration = 400,
    this.itemCurve = Curves.bounceInOut,
    this.stackAnimatedDuration = 600,
    this.columnNumber = 4,
    this.stackCurve = Curves.easeInOutQuint,
  }) : super(key: key);

  @override
  _AnimatedCategoryState createState() =>
      _AnimatedCategoryState<T>(childBuilder);
}

class _AnimatedCategoryState<T> extends State<AnimatedCategory>
    with TickerProviderStateMixin {
  _AnimatedCategoryState(this.childBuilder);

  ///Matrix which will be used for creating and managing items
  ///for grid view animation
  Map<int, List<SuggestionItem>> initialSuggestionMatrix = {};

  ///Child builder which we are using for building children
  ///as a callback function
  late Widget Function(SuggestionItem item, T data) childBuilder;

  bool needUpdateScrollWidth = true;
  int maxWidth = 0;

  late double startSize;
  late double deltaSize;
  late double deltaSizeBig;

  @override
  void initState() {
    super.initState();

    ///initial setup
    startSize = widget.startSize;
    deltaSize = widget.deltaSizeFirstTap;
    deltaSizeBig = widget.deltaSizeSecondTap;

    //add initial sizes
    int rowCount = (widget.items.length / widget.columnNumber).round();

    ///add empty data to the matrix
    for (int m = 0; m < widget.columnNumber; m++) {
      initialSuggestionMatrix.addAll({m: []});
    }

    initialSuggestionMatrix =
        Map.from(initialSuggestionMatrix.map((key, value) {
      final endIndex = (rowCount * (key + 1));
      return MapEntry(
          key,
          widget.items
              .getRange(
                  rowCount * key,
                  endIndex < widget.items.length
                      ? endIndex
                      : widget.items.length)
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
              x: (i) * startSize,
              y: (key) * startSize,
            );
          }).toList());
    }));

    _childrenCards(setClickedItemDelay: widget.clickedItemDelay != null);
  }

  @override
  void didUpdateWidget(covariant AnimatedCategory oldWidget) {
    super.didUpdateWidget(oldWidget);
    this.childBuilder = widget.childBuilder;
  }

  @override
  Widget build(BuildContext context) {
    _updateWidth();

    return FreeScrollView(
      child: Container(
          width: maxWidth * startSize,
          height: widget.columnNumber * deltaSizeBig,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.topCenter,
            children: _cardsMatrixWidgets.values.toList(),
          )),
    );
  }

  void _updateWidth() {
    if (needUpdateScrollWidth) {
      needUpdateScrollWidth = false;
      // maxWidth = 0;
      initialSuggestionMatrix.forEach((key, list) {
        final current =
            list.where((element) => element.currentWeight == 1).length;
        final currentExpand =
            list.where((element) => element.currentWeight == 2).length;
        final currentExpandMax =
            list.where((element) => element.currentWeight == 3).length;

        final all = current + (currentExpand * 2) + (currentExpandMax * 2);
        maxWidth = maxWidth < all ? all : maxWidth;
      });
    }
  }

  Map<Key, Widget> _cardsMatrixWidgets = {};
  Map<Key, Rect> _lastRenderedRects = {};
  void _childrenCards({required setClickedItemDelay}) {
    for (final columns in initialSuggestionMatrix.entries) {
      ///get columns and values from them
      int iColumn = columns.key;
      List<SuggestionItem> rowsList = columns.value;

      ///for every column we need update our rows
      for (final rows in rowsList.asMap().entries) {
        ///get rows and values from them
        int iRow = rows.key;
        SuggestionItem currentRow = rows.value;

        currentRow.iColumn = iColumn;
        currentRow.iRow = iRow;

        ///mark: update widgets with delay or not
        ///with delay we can use post updating for all wodgets
        ///
        ///[widget.clickedItemDelay] can't be null cause we doing check on [setClickedItemDelay] before
        if (setClickedItemDelay) {
          Future.delayed(
              Duration(
                  milliseconds:
                      (widget.clickedItemDelay! * (currentRow.iRow * 0.3))
                          .round()), () {
            _update(currentRow: currentRow, rowsList: rowsList);
            if (_lastRenderedRects[currentRow.widgetKey] != currentRow.rect) {
              _updateMatrix(currentRow, rows);
              setState(() {});
            }
          });
        } else {
          _update(currentRow: currentRow, rowsList: rowsList);
          if (_lastRenderedRects[currentRow.widgetKey] != currentRow.rect) {
            _updateMatrix(currentRow, rows);
          }
        }
      }
    }
  }

  void _updateMatrix(SuggestionItem currentRow, rows) {
    _lastRenderedRects[currentRow.widgetKey] = currentRow.rect;
    _cardsMatrixWidgets[currentRow.widgetKey] = AnimatedPositioned.fromRect(
      // key: currentRow.widgetKey,
      duration: Duration(milliseconds: widget.stackAnimatedDuration),
      curve: widget.stackCurve, //fastOutSlowIn,
      child: item(rows.value, currentRow.widgetKey),
      rect: currentRow.rect,
    );
  }

  void _update(
      {required SuggestionItem currentRow,
      required List<SuggestionItem> rowsList}) {
    if (currentRow.iRow > 0) {
      calcOverflowLeft(rowsList.elementAt(currentRow.iRow - 1), currentRow);
    }

    if (currentRow.iColumn > 0) {
      calcOverflowTop(
          initialSuggestionMatrix[currentRow.iColumn - 1]!
              .elementAt(currentRow.iRow),
          currentRow);

      calcOverflowClosestElement(
          line: initialSuggestionMatrix[currentRow.iColumn - 1]!,
          current: currentRow);
    }
  }

  bool calcOverflowClosestElement(
      {required List<SuggestionItem> line,
      required SuggestionItem current,
      bool check = false}) {
    for (SuggestionItem element in line) {
      if (current.rect.intersect(element.rect).height > 0 &&
          current.rect.intersect(element.rect).width > 0) {
        if (current.rect.intersect(element.rect).height > 0) {
          if (!check) {
            current.y += element.rect.intersect(current.rect).height;
          }
        }
      }
    }
    return false;
  }

  void calcOverflowLeft(SuggestionItem prev, SuggestionItem current,
      {bool? withGravity}) {
    if (prev.right > current.left) {
      current.x += prev.right - current.left;
    } else if (prev.right < current.left) {
      current.x -= current.left - prev.right;
    }
  }

  void calcOverflowTop(SuggestionItem prev, SuggestionItem current) {
    if (current.x == prev.x)
      current.y += prev.rect.intersect(current.rect).height;
  }

  Widget item(SuggestionItem e, Key key) {
    return AnimatedContainer(
      key: key,
      duration: Duration(milliseconds: widget.itemAnimationDuration),
      curve: widget.itemCurve,
      height: e.height,
      width: e.width,
      child: Padding(padding: EdgeInsets.all(8), child: childBuilder(e, e.data))
          .addOnTap(
        onLongPress: () {
          onLongPressItem(e);
          _childrenCards(setClickedItemDelay: widget.clickedItemDelay != null);
          setState(() {
            needUpdateScrollWidth = true;
          });
        },
        onTap: () {
          onTapItem(e);
          _childrenCards(setClickedItemDelay: widget.clickedItemDelay != null);
          setState(() {
            needUpdateScrollWidth = true;
          });
        },
      ),
    );
  }

  void onTapItem(SuggestionItem e) {
    if (e.currentWeight <= 1) {
      e.currentWeight = e.currentWeight + 1;
      e.height = e.height + deltaSize;
      e.width = e.width + deltaSize;
    } else {
      e.currentWeight = 1;
      e.height = startSize;
      e.width = startSize;
    }
    widget.itemSelected?.call(e);
  }

  void onLongPressItem(
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
    widget.itemSelected?.call(e);
  }
}
