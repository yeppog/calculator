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
      case "C":
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
        _output = evalExp(parseString(_output));
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


    setState(() {
      if (reset == 1) {
        output = "0";
        reset = 0;
      } else {
        output = _output;
      }
    });

  }

  double evalTwo(String num1, String num2, String op) {
    double evaluated;
    switch(op) {
      case ("+"):
        evaluated = double.parse(num1) + double.parse(num2);
        break;
      case ("-"):
        evaluated = double.parse(num1) - double.parse(num2);
        break;
      case ("/"):
        evaluated = double.parse(num1) / double.parse(num2);
        break;
      case ("X"):
        evaluated = double.parse(num1) * double.parse(num2);
        break;
    }
    return evaluated;
  }



  evalExp (List input) {
    List<String> operatorArr = ["+", "-", "/", "X", "(", ")"];
    if (input.length == 1) {
      return input.last;
    } else {
        String num1;
        String num2;
        String op;
        bool brackets = false;
        bool canEval = false;
        String strnum1;
        double strindex;
        double index;
        double output;
        double size = 2;
        List<String> outputArr = List<String>();

        for (int i = 0; i < input.length; i++ ) {
          print(num1);
          if (canEval) {
            break;
          } else if (input[i] == "(") {
              brackets = true;
          } else if (input[i] == ")") {
              brackets = false;
              canEval = true;
          } else if (!operatorArr.contains(input[i])) {
              if (num1 == null) {
                strnum1 = input[i];
                strindex = i.toDouble();
                index = i.toDouble();
                num1 = input[i];
              } else if (num2 == null) {
                num2 = input[i];
                strnum1 = input[i];
                strindex = i.toDouble();
              } else {
                strnum1 = input[i];
                strindex = i.toDouble();
              }
          } else if (operatorArr.contains(input[i])) {
              if (brackets) {
                index = strindex;
                num1 = strnum1;
                num2 = input[i + 1];
                op = input[i];
              } else if (input[i] == "/" || input[i] == "X") {
                  if (op == "-" || op == "+") {
                    index = strindex;
                    num1 = strnum1;
                    num2 = input[i + 1];
                    op = input [i];
                  } else if (op == null) {
                      op = input[i];
                  }
              } else if (op == null){
                  op = input[i];
              }
          }
        }
        output = evalTwo(num1, num2, op);
        for (int i = 0; i < input.length; i ++) {
          if (input[i] == "(" || input[i] == ")") {
          } else if (i == index) {
            outputArr.add(output.toString());
            i += size.toInt();
          } else {
            outputArr.add(input[i]);
          }
        }
        print(num1);
        print(num2);
        print(op);
        print(outputArr);
        return evalExp(outputArr);
    }
  }


  List parseString (String input) {
    String store = "";
    List<String> outputArr = new List<String>();
    List<String> operatorArr = ["+", "-", "/", "X", "(", ")"];
    double openCount = 0;
    double closeCount = 0;
    double error = 0;
    for (int i = 0; i < input.length; i ++ ) {
      if (operatorArr.contains(input[i])) {
        if (input[i] == "(") {
          openCount += 1;
        } else if (input[i] == ")") {
          closeCount += 1;
        }
        if (closeCount > openCount) {
          error = 1;
        }
        if (store.length != 0) {
          outputArr.add(store);
          store = "";
        }
        outputArr.add(input[i]);
      } else if (i == input.length - 1) {
          if (store.length != 0) {
            store += input[i];
            outputArr.add(store);
          } else {
            outputArr.add(input[i]);
          }
      } else {
        store += input[i];
      }
    }
    if (error != 1) {
      return outputArr;
    } else {
      return null;
    }

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
                buildButton("("),
                buildButton("+")
              ]),

              Row(children: [
                buildButton("C"),
                buildButton("DEL"),
                buildButton(")"),
                buildButton("=")
              ])
              ])
            ])
          )
        );
  }
}
