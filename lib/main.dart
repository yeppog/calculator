import 'dart:math';

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
        _output = evalExp(parseString(_output, _selections[0])).toString();
        break;
      case "DEL":
        {
          _output = _output.substring(0, _output.length - 1);
        } break;
      default:
          { _output += buttonText; }
          break;
    }
    setState(() {
      if (reset == 1) {
        output = "0";
        reset = 0;
      } else {
        output = _output;
      }
    });

  }



  Number evalTwo(Number num1, Number num2, String op) {
    Number evaluated;
    switch(op) {
      case ("+"):
        return num1 + num2;
        break;
      case ("-"):
        return num1 - num2;
        break;
      case ("/"):
        return num1 / num2;
        break;
      case ("X"):
        return num1 * num2;
        break;
      default:
        return null;
    }
  }



  evalExp (List input) {
    List<String> operatorArr = ["+", "-", "/", "X", "(", ")"];
    if (input.length == 0) {
      return "";
    }
    else if (input.length == 1) {
      return input.last;
    } else {
        Number num1;
        Number num2;
        String op;
        bool brackets = false;
        bool canEval = false;
        Number storePrevious;
        int previousIndex;
        int indexOfNum1; // position of number 1
        Number output;
        double size = 2;
        List outputArr = List();

        for (int i = 0; i < input.length; i++ ) {
          if (canEval) {
            break;
          } else if (input[i] == "(") {
              brackets = true;
          } else if (input[i] == ")") {
              brackets = false;
              canEval = true;
          } else if (!operatorArr.contains(input[i])) {
              if (num1 == null) { // only assign num1 if it is hasn't been assigned
                storePrevious = input[i];
                previousIndex = i;
                indexOfNum1 = i;
                num1 = input[i];
              } else if (num2 == null) {
                num2 = input[i];
                storePrevious = input[i];
                previousIndex = i;
              } else {
                storePrevious = input[i];
                previousIndex = i;
              }

          } else if (operatorArr.contains(input[i])) {
              if (brackets) {
                indexOfNum1 = previousIndex;
                num1 = storePrevious;
                num2 = input[i + 1];
                op = input[i];
              } else if (input[i] == "/" || input[i] == "X") { // check if there are operators of higher precedence
                  if (op == "-" || op == "+") {
                    indexOfNum1 = previousIndex;
                    num1 = storePrevious;
                    num2 = input[i + 1];
                    op = input [i];
                  } else if (op == null) {
                      op = input[i];
                  }
              } else if (op == null){ // only assign operator if it hasn't been assigned
                  op = input[i];
              }
          }
        }

        output = evalTwo(num1, num2, op);

        for (int i = 0; i < input.length; i ++) {
          if (input[i] == "(" || input[i] == ")") {
          } else if (i == indexOfNum1) {
            outputArr.add(output);
            i += size.toInt();
          } else {
            outputArr.add(input[i]);
          }
        }

        return evalExp(outputArr);
    }
  }


  List parseString (String input, bool rational) {
    String store = "";
    List outputArr = new List();
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
          if (rational) {
            outputArr.add(RationalNumber(store));
          } else {
            outputArr.add(Number(store));
          }

          store = "";
        }
        outputArr.add(input[i]);
      } else if (i == input.length - 1) {
          if (store.length != 0) {
            store += input[i];
            if (rational) {
              outputArr.add(RationalNumber(store));
            } else {
              outputArr.add(Number(store));
            }

          } else {
            if (rational) {
              outputArr.add(RationalNumber(input[i]));
            } else {
              outputArr.add(Number(input[i]));
            }

          }
      } else {
        store += input[i];
      }
    }
    if (error != 1) {
      print(outputArr);
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





class Number {
  double numerator;
  double denominator;

  Number(String numerator, [String denominator = "1"]) {
    this.numerator = double.parse(numerator);
    this.denominator = double.parse(denominator);
  }
  String toString() {
    return numerator.toString();
  }
  Number operator + (Number input) {
    return Number((numerator + input.numerator).toString());
  }
  Number operator - (Number input) {
    return Number((numerator - input.numerator).toString());
  }
  Number operator / (Number input) {
    return Number((numerator / input.numerator).toString());
  }
  Number operator * (Number input) {
    return Number((numerator * input.numerator).toString());
  }
}




class RationalNumber extends Number{
  double numerator;
  double denominator;
  // takes in the input and immediately reduces the fraction to simplest form
  // overloaded constructor for inputs that have no denominator
  RationalNumber (String numerator, [String denominator = "1"]) : super(numerator, denominator){
    if (denominator != "1") {
      int intNumerator = double.parse(numerator).toInt();
      int intDenominator = double.parse(denominator).toInt();
      int gcd = intNumerator.gcd(intDenominator);
      this.numerator = (intNumerator ~/ gcd).toDouble();
      this.denominator = (intDenominator ~/ gcd).toDouble();
    } else {
      this.numerator = double.parse(numerator);
      this.denominator = double.parse(denominator);
    }
  }

  // output the fractional representation of the rational number
  String toString () {
    if (denominator != 1) {
      return numerator.toInt().toString() + "/" + denominator.toInt().toString();
    } else {
      return (numerator / denominator).toString();
    }
  }
  // to reduce back to decimal
  String toDecimal() {
    return (numerator / denominator).toString();
  }


  RationalNumber operator + (Number input) {
    int gcd = denominator.toInt().gcd(input.denominator.toInt());
    int lcm = denominator * input.denominator ~/ gcd;
    double outputNumerator = lcm ~/ denominator * numerator + lcm ~/ input.denominator * input.numerator;
    int outputDenominator = lcm;
    return RationalNumber(outputNumerator.toString(), outputDenominator.toString());
  }

  RationalNumber operator - (Number input) {
    int gcd = denominator.toInt().gcd(input.denominator.toInt());
    int lcm = denominator * input.denominator ~/ gcd;
    double outputNumerator = lcm ~/ denominator * numerator - lcm ~/ input.denominator * input.numerator;
    int outputDenominator = lcm;
    return RationalNumber(outputNumerator.toString(), outputDenominator.toString());
  }
  RationalNumber operator * (Number input) {
    double outputNumerator = this.numerator * input.numerator;
    double outputDenominator = denominator * input.denominator;
    return RationalNumber(outputNumerator.toString(), outputDenominator.toString());
  }

  RationalNumber operator / (Number input) {
    double outputNumerator = numerator * input.denominator;
    double outputDenominator = denominator * input.numerator;
    return RationalNumber(outputNumerator.toString(), outputDenominator.toString());
  }
}