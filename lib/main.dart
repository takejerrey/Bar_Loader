import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bar Loader',
      theme: ThemeData.dark(),
      home: StackDemo(),
    );
  }
}

class StackDemo extends StatefulWidget {
  @override
  _StackDemoState createState() => _StackDemoState();
}

class _StackDemoState extends State<StackDemo> {
  bool _isKg = false;
  int dump = 0;
  double _totalPounds = 45;
  double _totalKilos = 20;
  double _barWeightLb = 45;
  double _barWeightKg = 20;
  double _topOffset = 0;
  double _leftOffset = 0;
  double _rightOffset = 0;
  List<double> _stackLb = [0];
  List<double> _stackKg= [0];
  List<Color> _rectangleColors = [];

  void _toggleConversion(bool value) {
    _clearStack();
    setState(() {
      _isKg = value;
    });
  }

  void _setInitialWeight(double val){
    setState(() {
      if(_isKg){
        _stackKg.add(val);
        _totalKilos = val;
      }
      else {
        _stackLb.add(val);
        _totalPounds = val;
      }
    });
  }

  void _addToStack(double value, Color color) {
    setState(() {
      if(_isKg){
        _stackKg.add(value);
        _totalKilos += value * 2;
      }
      else {
        _stackLb.add(value);
        _totalPounds += value * 2;
      }
      _rectangleColors.add(color); // Add the color to the list
    });
  }


  Widget _buildSideProfileLeft() {
    List<Widget> leftProfileWidgets = [];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double _width = 10;
    double _height = 100;
    _leftOffset = screenWidth * 0.3;
    _topOffset = screenHeight * 0.43;
    for (var color in _rectangleColors) {
      if(color == Colors.pinkAccent){
        _topOffset = screenHeight * 0.474;
        _leftOffset -= 3;
        _width = 15;
        _height = 25;
      }
      leftProfileWidgets.add(
        Positioned(
          left: _leftOffset, // Replace with specific X-coordinate for left profiles
          top: _topOffset,
          child: _buildRoundedRectangle(color,_width,_height),
        ),
      );

      _leftOffset -= 12; // Increment by rectangle's height for stacking
    }

    return Stack(
      children: leftProfileWidgets,
    );
  }

  Widget _buildSideProfileRight() {
    List<Widget> rightProfileWidgets = [];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double _width = 10;
    double _height = 100;
    _rightOffset = screenWidth * 0.3;
    _topOffset = screenHeight * 0.43;

    for (var color in _rectangleColors) {
      if(color == Colors.pinkAccent){
        _topOffset = screenHeight * 0.474;
        _rightOffset -= 3;
        _width = 15;
        _height = 25;
      }
      rightProfileWidgets.add(
        Positioned(
          right: _rightOffset, // Replace with specific X-coordinate for right profiles
          top: _topOffset,
          child: _buildRoundedRectangle(color,_width,_height),
        ),
      );

      _rightOffset -= 12; // Increment by rectangle's height for stacking
    }

    return Stack(
      children: rightProfileWidgets,
    );
  }

  Widget _buildRoundedRectangle(Color color, double wide, double high) {
    double _w = wide;
    double _h = high;
    return Container(
      width: _w, // Set the width of the rectangle
      height: _h, // Set the height of the rectangle
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(25),
          right: Radius.circular(25),
        ),
      ),
    );
  }

  Widget _buildBar() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    _topOffset = screenHeight * .48;
    _leftOffset = screenWidth * 0.117;

    return Stack(
      children: <Widget>[
        Positioned(
          left: _leftOffset,
          top: _topOffset,
          child: Container(
            width: 300,
            height: 15,
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(7.5),
                right: Radius.circular(7.5),
              ),
            ),
          ),
        ),
        Positioned(
          left: screenWidth * .3 + 8, // Adjust this value as needed
          top:  screenHeight * 0.474,  // Adjust this value as needed
          child: _buildRoundedRectangle(Colors.blueGrey, 15, 25), // Additional rectangle
        ),
        Positioned(
          right: screenWidth * .3 + 8, // Adjust this value as needed
          top:   screenHeight * 0.474,  // Adjust this value as needed
          child: _buildRoundedRectangle(Colors.blueGrey, 15, 25), // Additional rectangle
        ),
      ],
    );
  }


  void _removeFromStack() {
    if(_isKg){
      if (_stackKg.isNotEmpty) {
        setState(() {
          double poppedVal = _stackKg.removeLast();
          _totalKilos -= poppedVal * 2;
          if(_totalKilos < _barWeightKg){
            _totalKilos = _barWeightKg;
          }
        });
      }
    }
    else {
      if (_stackLb.isNotEmpty) {
        setState(() {
          double poppedVal = _stackLb.removeLast();
          _totalPounds -= poppedVal * 2;
          if(_totalPounds< _barWeightLb){
            _totalPounds = _barWeightLb;
          }
        });
      }
    }
    _rectangleColors.removeLast();
  }

  void _clearStack() {
    setState(() {
      if(_isKg) {
        _totalKilos = _barWeightKg;
        _stackKg.clear();
      }
      else{
        _stackLb.clear();
        _totalPounds = _barWeightLb;
      }
      _rectangleColors.clear();
    });
  }
  String _getWeightText() {
    if (_isKg) {
      return 'Weight: ${_totalKilos.toStringAsFixed(2)} kg';
    } else {
      return 'Weight: ${_totalPounds.toStringAsFixed(2)} lb';
    }
  }

  void _promptAddBarWeight() {
    // Implement the method to show a dialog or input method
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return the dialog here
        double _enteredWeight = 0;
        return AlertDialog(
          title: Text('Enter Bar Weight'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _enteredWeight = double.tryParse(value) ?? 0;
            },
            decoration: InputDecoration(hintText: "Weight"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _clearStack();
                if(_isKg){
                  //_clearStack();
                  _barWeightKg = _enteredWeight;
                  _setInitialWeight(_enteredWeight);
                }else{
                  //_clearStack();
                  _barWeightLb = _enteredWeight;
                  _setInitialWeight(_enteredWeight);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bar Loader'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.remove_circle_outline),
            onPressed: _removeFromStack,
            tooltip: 'Remove Outer Weight',
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.delete),
          onPressed: _clearStack,
          tooltip: 'Clear Bar',
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Your main column content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Switch(
                  value: _isKg,
                  onChanged: _toggleConversion,
                ),
                Text(
                  _getWeightText(),
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),

          _buildBar(),
          // Left and Right side profile builders
          _buildSideProfileLeft(),
          _buildSideProfileRight(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            _buildButton(55),
            _buildButton(45),
            _buildButton(35),
            _buildButton(25),
            _buildButton(10),
            _buildButton(5),
            _buildButton(2.5),
            _buildButton(123456789),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _promptAddBarWeight,
        child: Icon(Icons.change_circle),
      ),
    );
  }


  Widget _buildButton(double value) {
    double val = value;
    String name;
    Color buttonColor;
    TextStyle textStyle = TextStyle(color: Colors.white);
    switch (value) {
      case 123456789:
        buttonColor = Colors.pinkAccent;
        textStyle = TextStyle(color: Colors.black);
        if(_isKg){
          val = 2.5;
        }
        else{
          val = 5.5;
        }
        name = "C";
        break;
      case 55:
        buttonColor = Colors.red;
        if(_isKg){
          val = 25;
        }
        name = val.toString();
        break;
      case 45:
        buttonColor = Colors.blue;
        if(_isKg){
          val = 20;
        }
        name = val.toString();
        break;
      case 35:
        buttonColor = Colors.yellow;
        if(_isKg){
          val = 15;
        }
        name = val.toString();
        textStyle = TextStyle(color: Colors.black);
        break;
      case 25:
        buttonColor = Colors.green;
        if(_isKg){
          val = 10;
        }
        name = val.toString();
        break;
      case 10:
        buttonColor = Colors.white;
        if(_isKg){
          val = 5;
        }
        name = val.toString();
        textStyle = TextStyle(color: Colors.black);
        break;
      case 5:
        buttonColor = Colors.blueGrey; // Default color for other values
        if(_isKg){
          val = 2.5;
        }
        name = val.toString();
        break;
      case 2.5:
        buttonColor = Color(0xFFC0C0C0);
        if(_isKg){
          val = 1.25;
        }
        name = val.toString();
        textStyle = TextStyle(color: Colors.black);
        break;
      default:
        name = val.toString();
        buttonColor = Colors.blueGrey; // Default color for other values
    }
    return ElevatedButton(
      onPressed: () => _addToStack(val,buttonColor),
      child: Text(name, style: textStyle),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: CircleBorder(),
        padding: EdgeInsets.all(20),
      ),
    );
  }
}

// Reset picture on swap, and do NOT save weight
// in parenthesis or something put the weight in the opposite conversion
 // so people can easily see and keep adding weights in their respective format
// if plate is hit with collars on, it makes plate size of collars