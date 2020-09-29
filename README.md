# animated_category_view

Flutter library for picking category

## Getting Started

## Example

![GitHub Logo](gif.gif?raw=true)
![GitHub Logo](logo.video?raw=true)


## Usage

First you need to add a library to `pubspec.yaml`:
```
dependencies:
  animated_category: any
```

Add to you files where used:
```
import 'package:animated_category/animated_category.dart';
```

Now you can using it like in example:
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