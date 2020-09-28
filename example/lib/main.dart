import 'package:animated_category/suggestion_item.dart';
import 'package:flutter/material.dart';
import 'package:animated_category/animated_category.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  List<MyData> categories = List.generate(
      30,
      (index) => MyData(
          img:
              'https://upload.wikimedia.org/wikipedia/commons/a/a4/Philip_II_by_Alonso_Sanchez_Coello.jpg'));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double itemSize = screenHeight / 3;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AnimatedCategory<MyData>(
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyData {
  String img;

  MyData({this.img});
}
