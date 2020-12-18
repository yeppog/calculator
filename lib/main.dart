import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:dart_numerics/dart_numerics.dart' as numerics;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Shitty Calculator',
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
  List<bool> _selections = List.generate(1,(_) => false);
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
        print(evalTwoRat("15", "15/9", "X"));
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

  // checks if the input is a rational
  bool isRat (String input) {
    return input.contains("/");
  }

  splitRat (String input) {
    List<int> outputArr = new List<int>(2);
    String holder = "";
    for (int i = 0; i < input.length; i++) {
      if (input[i] == "/" ) {
        outputArr[0] = int.parse(holder);
        holder = "";
      } else if (i == input.length - 1) {
        holder += input[i];
        outputArr[1] = int.parse(holder);
      } else if (input[i] != "/"){
        holder += input[i];
      }
    }
    return outputArr;
  }

  String simplifyRat (String input) {
    List<int> storeArr = splitRat(input);
    // find the gcd of the two numbers
    int gcd = storeArr[0].gcd(storeArr[1]);
    if (gcd > 0) {
      storeArr[0] = storeArr[0] ~/ gcd;
      storeArr[1] = storeArr[1] ~/ gcd;
      if (storeArr[1] == 1) {
        return storeArr[0].toString();
      } else {
        return storeArr[0].toString() + "/" + storeArr[1].toString();
      }
    } else {
      return "NaN";
    }

  }

  String evalTwoRat(String num1, String num2, String op) {

    String evaluated;
    switch(op) {
      case ("+"):
        if (isRat(num1) && isRat(num2)) {
          List<int> num1Store = splitRat(num1);
          List<int> num2Store = splitRat(num2);
          int gcd = num1Store[1].gcd(num2Store[1]);
          int lcm = num1Store[1] * num2Store[1] ~/ gcd;
          int numerator = lcm~/num1Store[1] * num1Store[0] + lcm~/num2Store[1] * num2Store[0];
          evaluated = simplifyRat(numerator.toString() + "/" + lcm.toString());
        } else if (!isRat(num1) && !isRat(num2)) {
          evaluated = (double.parse(num1) + double.parse(num2)).toString();
        } else {
          if (isRat(num1)) {
            List<int> num1Store = splitRat(num1);
            int numerator = int.parse(num2) * num1Store[1] + num1Store[0];
            evaluated = simplifyRat(numerator.toString() + "/" + num1Store[1].toString());
          } else {
            List<int> num2Store = splitRat(num2);
            int numerator = int.parse(num1) * num2Store[1] + num2Store[0];
            evaluated = simplifyRat(numerator.toString() + "/" + num2Store[1].toString());
          }
        }
        break;
      case ("-"):
        if (isRat(num1) && isRat(num2)) {
          List<int> num1Store = splitRat(num1);
          List<int> num2Store = splitRat(num2);
          int gcd = num1Store[1].gcd(num2Store[1]);
          int lcm = num1Store[1] * num2Store[1] ~/ gcd;
          int numerator = lcm~/num1Store[1] * num1Store[0] - lcm~/num2Store[1] * num2Store[0];
          evaluated = simplifyRat(numerator.toString() + "/" + lcm.toString());
        } else if (!isRat(num1) && !isRat(num2)) {
          evaluated = (double.parse(num1) + double.parse(num2)).toString();
        } else {
          if (isRat(num1)) {
            List<int> num1Store = splitRat(num1);
            int numerator = num1Store[0] - int.parse(num2) * num1Store[1];
            evaluated = simplifyRat(numerator.toString() + "/" + num1Store[1].toString());
          } else {
            List<int> num2Store = splitRat(num2);
            int numerator = num2Store[0] - int.parse(num1) * num2Store[1];
            evaluated = simplifyRat(numerator.toString() + "/" + num2Store[1].toString());
          }
        }
        break;
      case ("/"):
        if (isRat(num1) && isRat(num2)) {
          List<int> num1Store = splitRat(num1);
          List<int> num2Store = splitRat(num2);
          evaluated = simplifyRat((num1Store[0] * num2Store[1]).toString() + "/" + (num1Store[1] * num2Store[0]).toString());
        } else if (!isRat(num1) && !isRat(num2)) {
          evaluated = simplifyRat(num1 + "/" + num2);
        } else {
          if (isRat(num1)) {
            List<int> num1Store = splitRat(num1);
            evaluated = simplifyRat(num1Store[0].toString() + "/" + (num1Store[1] * int.parse(num2)).toString());
          } else {
            List<int> num2Store = splitRat(num2);
            evaluated = simplifyRat(num2Store[0].toString() + "/" + (num2Store[1] * int.parse(num2)).toString());
          }
        }
        break;
      case ("X"):
        if (isRat(num1) && isRat(num2)) {
          List<int> num1Store = splitRat(num1);
          List<int> num2Store = splitRat(num2);
          evaluated = simplifyRat((num1Store[0] * num2Store[0]).toString() + "/" + (num1Store[1] * num2Store[1]).toString());
        } else if (!isRat(num1) && !isRat(num2)) {
          evaluated = (int.parse(num1) * int.parse(num2)).toString();
        } else {
          if (isRat(num1)) {
            List<int> num1Store = splitRat(num1);
            evaluated = simplifyRat((num1Store[0] * int.parse(num2)).toString() + "/" + num1Store[1].toString());
          } else {
            List<int> num2Store = splitRat(num2);
            evaluated = simplifyRat((num2Store[0] * int.parse(num1)).toString() + "/" + num2Store[1].toString());
          }
        }
        break;
    }
    return evaluated.toString();
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
    if (input.length == 0) {
      return "";
    }
    else if (input.length == 1) {
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
        String output;
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
        if (_selections[0] == true) {
          output = evalTwoRat(num1, num2, op);
        } else {
          output = evalTwo(num1, num2, op).toString();
        }
        for (int i = 0; i < input.length; i ++) {
          if (input[i] == "(" || input[i] == ")") {
          } else if (i == index) {
            outputArr.add(output);
            i += size.toInt();
          } else {
            outputArr.add(input[i]);
          }
        }
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 5.0,
              ),
              child: ToggleButtons(
                children: [
                  Icon(Icons.calculate),
                ],
                isSelected: _selections,
                onPressed: (int index) {
                  setState(() {
                    _selections[index] = !_selections[index];
                  });
                }
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: new EdgeInsets.symmetric(
                vertical: 6.0,
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
