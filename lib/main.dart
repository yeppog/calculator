import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Calculator'),
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
  // app state deprecated
  // String output = "0";
  // String _output = "0";
  // double num1 = 0.0;
  // double num2 = 0.0;
  // String operand = "";
  // function to handle each button press
  // Takes in the buttonText as a parameter
// Old button pressed function that parses the input one by one.
//   buttonPressedDeprecated(String buttonText) {
//     switch(buttonText) {
//       case "CLEAR":
//         {
//           _output = "0";
//           output = "0";
//           num1 = 0.0;
//           num2 = 0.0;
//           operand = "";
//         } break;
//       case "+":
//       case "-":
//       case "X":
//       case "/":
//         {
//           num1 = double.parse(output);
//           operand = buttonText;
//           _output = "0";
//         }
//         break;
//       case ".":
//         {
//           if (_output.contains(".")) {
//             print("Already has a decimal in the output");
//           } else {
//             _output += buttonText;
//           }
//         } break;
//       case "=": // if equals, we would evaluate the
//         {
//           num2 = double.parse(output);
//
//           switch (operand) {
//             case "+":
//               {
//                 _output = (num1 + num2).toString();
//               }
//               break;
//             case "-":
//               {
//                 _output = (num1 - num2).toString();
//               }
//               break;
//             case "X":
//               {
//                 _output = (num1 * num2).toString();
//               }
//               break;
//             case "/":
//               {
//                 _output = (num1 / num2).toString();
//               }
//               break;
//           }
//           print(_output);
//           num1 = 0.0;
//           num2 = 0.0;
//           operand = "";
//         } break;
//
//       default:
//         _output += buttonText;
//     }
//
//     print(_output);
//
//     setState(() {
//       output = double.parse(_output).toStringAsFixed(2);
//     });
//
//   }

  String output = "0";
  String _output;
  List<String> outputArr = List<String>();
  String tempStore = "0";


  void buttonPressed(String buttonText) {
    switch(buttonText) {
      case "CLEAR":
        {
          _output = null;
          output = "0";
          tempStore = null;
          outputArr = List<String>();
        } break;
      case "+":
      case "-":
      case "X":
      case "/":
        {
          if (tempStore != null) {
            outputArr.add(tempStore);
            tempStore = null;
          }

          if (outputArr.last == "+" || outputArr.last == "-" || outputArr.last == "/" || outputArr.last == "X") {
            outputArr.last = buttonText;
            _output = _output.substring(0, _output.length - 1) + buttonText;
          } else {
            outputArr.add(buttonText);
            _output += buttonText;
          }
        }
        break;
      case ".":
        {_output += buttonText;}
        break;
      case "=":
        break;
      case "DEL":
        {
          if (outputArr.length != 0) {
            if (outputArr.last == "+" || outputArr.last == "-" || outputArr.last == "/" || outputArr.last == "X") {
              outputArr.removeLast();
              _output = _output.substring(0, _output.length - 1);
            }
          }
          else if (_output != null ) {
            tempStore = tempStore.substring(0, tempStore.length - 1);
            _output = _output.substring(0, _output.length - 1);
          }
        } break;
      default:
        if (tempStore == null) {
          tempStore = buttonText;
        } else {
          tempStore += buttonText;
        } if (_output == null) {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
    }
    // debug
    print(_output);
    print(outputArr);

    setState(() {
      if (_output != null) {
        output = _output;
      } else if (_output == "") {
        output = "0";
      }
    });

  }


  parseInput(String input) {

  }
  // Widget for each button, calls out the onPressed function which updates the
  // state of the calculator
  Widget buildButton(String buttonText) {
    return new Expanded(
      child: new OutlineButton(
        padding: new EdgeInsets.all(24.0),
        child: new Text (buttonText,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          )
        ),
        onPressed: () =>
          buttonPressed(buttonText)
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: new EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 12.0
              ),
              child: Text(output, style: TextStyle (
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
              ))
            ),
            Expanded(
              child: new Divider(),
            ),

            Column (children: [
              Row (children: [
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
                buildButton("/")
              ]),

              Row(children: [
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
                buildButton("X")
              ]),

              Row(children: [
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
                buildButton("-")
              ]),

              Row(children: [
                buildButton("."),
                buildButton("0"),
                buildButton("00"),
                buildButton("+")
              ]),

              Row(children: [
                buildButton("CLEAR"),
                buildButton("DEL"),
                buildButton("="),
              ])
              ])
            ])
          )
        );
  }
}
