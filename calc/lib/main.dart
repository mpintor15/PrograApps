import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = "0";
  String _currentNumber = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operand = "";

  void _buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _currentNumber = "";
      _num1 = 0;
      _num2 = 0;
      _operand = "";
      _output = "0";
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "/" || buttonText == "x") {
      if (_currentNumber.isNotEmpty) {
        _num1 = double.tryParse(_currentNumber) ?? 0;
      } else {
        _num1 = double.tryParse(_output) ?? 0;
      }
      _operand = buttonText;
      _currentNumber = "";
    } else if (buttonText == ".") {
      if (_currentNumber.contains(".")) {
        return;
      }
      _currentNumber += buttonText;
      _output = _currentNumber;
    } else if (buttonText == "=") {
      if (_currentNumber.isNotEmpty) {
        _num2 = double.tryParse(_currentNumber) ?? 0;
      }
      
      if (_operand == "+") {
        _output = (_num1 + _num2).toString();
      }
      if (_operand == "-") {
        _output = (_num1 - _num2).toString();
      }
      if (_operand == "x") {
        _output = (_num1 * _num2).toString();
      }
      if (_operand == "/") {
        if (_num2 == 0) {
          _output = "Error";
        } else {
          _output = (_num1 / _num2).toString();
        }
      }

      if (_output.endsWith(".0")) {
        _output = _output.substring(0, _output.length - 2);
      }

      _num1 = double.tryParse(_output) ?? 0;
      _operand = "";
      _currentNumber = "";
    } else {
      _currentNumber += buttonText;
      _output = _currentNumber;
    }

    setState(() {});
  }

  Widget _buildButton(String buttonText, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[200],
            foregroundColor: textColor ?? Colors.black,
            padding: const EdgeInsets.all(24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                _output,
                style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Divider(height: 1),
          Column(
            children: [
              Row(
                children: [
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                  _buildButton("/", color: Colors.orange, textColor: Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                  _buildButton("x", color: Colors.orange, textColor: Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                  _buildButton("-", color: Colors.orange, textColor: Colors.white),
                ],
              ),
              Row(
                children: [
                  _buildButton("C", color: Colors.red[300], textColor: Colors.white),
                  _buildButton("0"),
                  _buildButton("="),
                  _buildButton("+", color: Colors.orange, textColor: Colors.white),
                ],
              ),
              const SizedBox(height: 24),
            ],
          )
        ],
      ),
    );
  }
}
