# About
Flutter library for picking category. And now all over again. Initially, this task did not seem difficult, since we all know that there is a GridView or libraries such as [flutter_staggered_grid_view](https://pub.dartlang.org/packages/flutter_staggered_grid_view). After we tested and realized that the animation will not work in these cases, since the view is updated and even with the use of all sorts of Hero and other animations, we can't normally bind the element to and associate with the smooth transition animation, we started to rack our brains to the point of using some Wrap, Flexible, FlowLayout..widgets.

[More in Medium](https://followthemoney1.medium.com/how-to-make-a-complex-category-picker-animation-on-flutter-a3d01ea1961b)

## Example
Or you can check full example video in files ```video.mp4```


![GitHub Logo](file://gif.gif?raw=true)

## Getting Started

First you need to add a library to `pubspec.yaml`:
```
dependencies:
  animated_category: any
```

Add to you files where used:
```
import 'package:animated_category/animated_category.dart';
```


## Usage

```
AnimatedCategory<MyData>(
          childBuilder: (MyData item) {
           //TODO: return widget which you will be use
          },
          startSize: itemSize,
          deltaSizeFirstTap: itemSize / 3,
          deltaSizeSecondTap: itemSize * 1.8,
          items: categories,
          itemSelected: (SuggestionItem i) {
           //TOOD: any staff which you need when item selected
          },
        )
```
Complete example can be like:
```
 AnimatedCategory<UserPost>(
                              startSize: itemSize,
                              deltaSizeFirstTap: itemSize / 2,
                              deltaSizeSecondTap: itemSize * 1.8,
                              columnNumber: 2,
                              setClickedItemDelay: false,
                              items: controller.userPosts,
                              itemSelected: (SuggestionItem i) {},
                              childBuilder: (SuggestionItem item, UserPost data) {
                                return Container(
                                  child: Stack(alignment: Alignment.topCenter, children: [
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Card(
                                        child: UserPostView(
                                          showImage: item.isExpanded,
                                          titleMaxLines: !item.isExpanded ? 9 : 2,
                                          data: data,
                                          showDetailScreen: true,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: UserChipInfo(
                                        userId: data.userId,
                                        start: DateTime.fromMillisecondsSinceEpoch(int.parse(data.postedAt!)),
                                        now: data.schedule!,
                                      ),
                                    ),
                                  ]),
                                );
                              },
                            ),
```

You also can add delay to your expanded animation. You can combine delay animation with expanded curves so your animation will be looks like one item pushing another with expanssion so it will be more natural:
![GitHub Logo](file://gif2.gif?raw=true)
![GitHub Logo](file://gif3.gif?raw=true)


```
        ///mark: update widgets with delay or not
        ///with delay we can use post updating for all wodgets
        if (setClickedItemDelay) {
          Future.delayed(Duration(milliseconds: (widget.clickedItemDelay / 100 * currentRow.iRow! * 1.3).round()), () {
            _update(currentRow: currentRow, rowsList: rowsList);
            _updateMatrix(currentRow, rows);
          });
        } else {
          _update(currentRow: currentRow, rowsList: rowsList);

          _updateMatrix(currentRow, rows);
        }
```

All fields:
```
 const AnimatedCategory({
      Key key,
      @required this.childBuilder,
      @required this.items,
      @required this.itemSelected,
      this.setClickedItemDelay = false,
      this.clickedItemDelay = 100,
      this.startSize = 100.0,
      this.deltaSizeSecondTap = 200.0,
      this.deltaSizeFirstTap = 50.0,
      this.itemAnimationDuration = 400,
      this.itemCurve = Curves.bounceInOut,
      this.stackAnimatedDuration = 600,
      this.stackCurve = Curves.easeInOutQuint,
 }): super(key: key);
```
