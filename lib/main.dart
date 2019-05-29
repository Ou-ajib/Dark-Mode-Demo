import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const int duration = 300;
const double height = 50;
const double width = 90;
const double transition = width - height;

void main() => runApp(MaterialApp(home: MyHomePage(), debugShowCheckedModeBanner: false));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  Animation _animation;
  Animation _colorTween;
  AnimationController _controller;
  bool darkModeEnabled = false;
  Brightness _brightness =Brightness.light;
  String title = 'Light Mode';

  @override
  void initState() { 
    super.initState();
    _controller =AnimationController(duration: const Duration(milliseconds: duration), vsync: this);
    _animation = CurvedAnimation(curve: Curves.linear, parent: _controller);
    _animation.addListener(()=>setState((){}));
    _colorTween = ColorTween(begin: Colors.white, end: Color(0xff353439)).animate(_controller);
  }

  @override
  void dispose() { 
    _controller.dispose();
    super.dispose();
  }

  _togle() {
    if(!darkModeEnabled){
      darkModeEnabled =true;
      setState(() => title = '');
      _controller.forward().then((_) =>
        setState(() {
          _brightness =Brightness.dark;
          title = 'Dark Mode';
        })
      );
    }else{
      darkModeEnabled =false;
      setState(() => title = '');
      _controller.reverse().then((_) => 
        setState((){
          _brightness =Brightness.light;
          title = 'Light Mode';
        })
      );
    } 
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: _brightness,
        backgroundColor: _colorTween.value,
        title: Text(title, style: TextStyle(color: darkModeEnabled ? Colors.white : Colors.black))
      ),
      body: Container(
        color: _colorTween.value,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: duration),
                style: Theme.of(context).textTheme.display1.copyWith(color: darkModeEnabled ? Colors.white : Colors.black),
                child: Text(
                  'Hello and Welcome. All you need to do is click the switch and see the magic happen!!', 
                  style: TextStyle(fontSize: 22), textAlign: TextAlign.center
                )
              )
            ),
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () => _togle(),
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: 1 - _animation.value,
                        child: Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(height/2),
                            image: DecorationImage(
                              image: AssetImage('assets/bluesky.jpg'),
                              fit: BoxFit.cover
                            )
                          )
                        )
                      ),
                      Opacity(
                        opacity: _animation.value,
                        child: Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(height/2),
                            image: DecorationImage(
                              image: AssetImage('assets/nightsky.jpg'),
                              fit: BoxFit.cover
                            )
                          )
                        )
                      ),
                      Transform(
                        transform: Matrix4.translationValues(transition * _animation.value, 0, 0),
                        child: Stack(
                          children: <Widget>[
                            Opacity(
                              opacity: 1-_animation.value,
                              child: Image.asset('assets/sun.png', width: height, height: height,)
                            ),
                            Opacity(
                              opacity: _animation.value,
                              child: Image.asset('assets/moon.png', width: height, height: height,)
                            )
                          ]
                        )
                      )
                    ]
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}
