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
  String output = "0";
  String _output = "";
  String tempStore = "0";
  // check if there is a need to set output to "0"
  int reset;

  void buttonPressed(String buttonText) {
    switch(buttonText) {
      case "CLEAR":
        {
          _output = "";
          output = "0";
          reset = 1;
        } break;
      case "+":
      case "-":
      case "X":
      case "/":
        {
          String checker = _output[_output.length - 1];
          if (checker == "+" || checker == "-" || checker == "X" || checker == "/") {
            _output = _output.substring(0, _output.length - 1) + buttonText;
          } else {
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
          _output = _output.substring(0, _output.length - 1);
        } break;
      default:
          { _output += buttonText; }
          break;
    }
    // debug
    print(parseString(_output));

    setState(() {
      if (reset == 1) {
        output = "0";
        reset = 0;
      } else {
        output = _output;
      }
    });

  }




  List parseString (String input) {
    String store = "";
    List<String> outputArr = new List<String>();
    List<String> operatorArr = ["+", "-", "/", "X", "(", ")"];
    for (int i = 0; i < input.length; i ++ ) {
      if (operatorArr.contains(input[i])) {
        if (store.length != 0) {
          outputArr.add(store);
          store = "";
        }
        outputArr.add(input[i]);
      } else {
        store += input[i];
      }
    }
    return outputArr;
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
