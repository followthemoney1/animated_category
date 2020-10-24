# animated_category_view

https://socialify.git.ci/followthemoney1/animated_category/image?description=1&descriptionEditable=Flutter%20library%20for%20picking%20category&font=Raleway&forks=1&issues=1&language=1&owner=1&pattern=Charlie%20Brown&pulls=1&stargazers=1&theme=Dark

Flutter library for picking category

## Example
Or you can check full example video in files ```video.mp4```
![GitHub Logo](https://github.com/followthemoney1/animated_category/blob/master/gif.gif?raw=true)

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
            print(item.img);
            return Card(
              child: Image.network(item.img),
            );
          },
          startSize: itemSize,
          deltaSizeFirstTap: itemSize / 3,
          deltaSizeSecondTap: itemSize * 1.8,
          items: categories,
          itemSelected: (SuggestionItem i) {
            _incrementCounter();
          },
        )
```


All fields:
```
 const AnimatedCategory(
      {Key key,
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
      this.stackCurve = Curves.easeInOutQuint})
      : super(key: key);
```
