import 'package:flutter/material.dart';

class CalculatorDialog extends StatefulWidget {
  const CalculatorDialog({super.key});

  @override
  CalculatorDialogState createState() => CalculatorDialogState();
}

class CalculatorDialogState extends State<CalculatorDialog> {
  String _display = '0';
  String _currentInput = '';
  double? _firstNumber;
  double? _secondNumber;
  String? _operation;
  bool _shouldResetDisplay = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_shouldResetDisplay) {
        _display = '';
        _shouldResetDisplay = false;
      }

      if (_display == '0') {
        _display = number;
      } else {
        _display += number;
      }
      _currentInput = _display;
    });
  }

  void _onOperationPressed(String operation) {
    setState(() {
      if (_firstNumber == null) {
        _firstNumber = double.parse(_display);
        _operation = operation;
        _shouldResetDisplay = true;
      } else {
        _calculate();
        _operation = operation;
      }
    });
  }

  void _calculate() {
    if (_firstNumber != null &&
        _operation != null &&
        _currentInput.isNotEmpty) {
      _secondNumber = double.parse(_currentInput);

      double result = 0;
      switch (_operation) {
        case '+':
          result = _firstNumber! + _secondNumber!;
          break;
        case '-':
          result = _firstNumber! - _secondNumber!;
          break;
        case '×':
          result = _firstNumber! * _secondNumber!;
          break;
        case '÷':
          result = _secondNumber != 0 ? _firstNumber! / _secondNumber! : 0;
          break;
      }

      setState(() {
        _display = result.toString();
        _firstNumber = result;
        _currentInput = '';
        _shouldResetDisplay = true;
      });
    }
  }

  void _clear() {
    setState(() {
      _display = '0';
      _currentInput = '';
      _firstNumber = null;
      _secondNumber = null;
      _operation = null;
      _shouldResetDisplay = false;
    });
  }

  void _onEqualsPressed() {
    _calculate();
    setState(() {
      _operation = null;
      _firstNumber = null;
    });
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onNumberPressed(number),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
          ),
          child: Text(
            number,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildOperationButton(String operation, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onOperationPressed(operation),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Color.fromARGB(255, 133, 66, 77),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
          ),
          child: Text(
            operation,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    VoidCallback onPressed, {
    Color? color,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 239, 195, 202),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Anzeige
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 20),

            // Tasten
            Column(
              children: [
                // Erste Reihe
                Row(
                  children: [
                    _buildActionButton(
                      'C',
                      _clear,
                      color: Color.fromARGB(255, 85, 37, 45),
                    ),
                    _buildOperationButton('÷'),
                    _buildOperationButton('×'),
                    _buildOperationButton('-'),
                  ],
                ),

                // Zweite Reihe
                Row(
                  children: [
                    _buildNumberButton('7'),
                    _buildNumberButton('8'),
                    _buildNumberButton('9'),
                    _buildOperationButton('+'),
                  ],
                ),

                // Dritte Reihe
                Row(
                  children: [
                    _buildNumberButton('4'),
                    _buildNumberButton('5'),
                    _buildNumberButton('6'),
                    _buildActionButton(
                      '=',
                      _onEqualsPressed,
                      color: Color.fromARGB(255, 85, 37, 45),
                    ),
                  ],
                ),

                // Vierte Reihe
                Row(
                  children: [
                    _buildNumberButton('1'),
                    _buildNumberButton('2'),
                    _buildNumberButton('3'),
                    _buildNumberButton('0'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Schließen Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 133, 66, 77),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                ),
                child: const Text('Schließen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
