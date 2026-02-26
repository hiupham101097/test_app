import 'package:flutter/services.dart';
import 'package:flutter/material.dart' show TextField;
import 'package:intl/intl.dart';

import 'dart:math';

import 'package:merchant/utils/helpers/extension/extension_helper.dart';

///
/// An implementation of [NumberInputFormatter] automatically inserts thousands
/// separators to numeric input. For example, a input of `1234` should be
/// formatted to `1,234`.
///
class ThousandsFormatter extends NumberInputFormatter {
  static final NumberFormat _formatter = NumberFormat.decimalPattern();

  final FilteringTextInputFormatter _decimalFormatter;
  final String _decimalSeparator;
  final RegExp _decimalRegex;

  final NumberFormat? formatter;
  final bool allowFraction;

  ThousandsFormatter({this.formatter, this.allowFraction = false})
    : _decimalSeparator = (formatter ?? _formatter).symbols.DECIMAL_SEP,
      _decimalRegex = RegExp(
        allowFraction
            ? '[0-9]+([${(formatter ?? _formatter).symbols.DECIMAL_SEP}])?'
            : r'\d+',
      ),
      _decimalFormatter = FilteringTextInputFormatter(
        RegExp(
          allowFraction
              ? '[0-9]+([${(formatter ?? _formatter).symbols.DECIMAL_SEP}])?'
              : r'\d+',
        ),
        allow: true,
      );

  @override
  String? _formatPattern(String? digits) {
    if (digits == null || digits.isEmpty) return digits;
    final number =
        allowFraction
            ? double.tryParse(digits) ?? 0.0
            : int.tryParse(digits) ?? 0;
    final result = (formatter ?? _formatter).format(number);
    if (allowFraction && digits.endsWith(_decimalSeparator)) {
      return '$result$_decimalSeparator';
    }
    return result;
  }

  @override
  TextEditingValue _formatValue(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _decimalFormatter.formatEditUpdate(oldValue, newValue);
  }

  @override
  bool _isUserInput(String s) {
    return s == _decimalSeparator || _decimalRegex.firstMatch(s) != null;
  }
}

///
/// An implementation of [NumberInputFormatter] that converts a numeric input
/// to credit card number form (4-digit grouping). For example, a input of
/// `12345678` should be formatted to `1234 5678`.
///
class CreditCardFormatter extends NumberInputFormatter {
  static final RegExp _digitOnlyRegex = RegExp(r'\d+');
  static final FilteringTextInputFormatter _digitOnlyFormatter =
      FilteringTextInputFormatter(_digitOnlyRegex, allow: true);

  final String separator;

  CreditCardFormatter({this.separator = ' '});

  @override
  String _formatPattern(String digits) {
    StringBuffer buffer = StringBuffer();
    int offset = 0;
    int count = min(4, digits.length);
    final length = digits.length;
    for (; count <= length; count += min(4, max(1, length - count))) {
      buffer.write(digits.substring(offset, count));
      if (count < length) {
        buffer.write(separator);
      }
      offset = count;
    }
    return buffer.toString();
  }

  @override
  TextEditingValue _formatValue(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _digitOnlyFormatter.formatEditUpdate(oldValue, newValue);
  }

  @override
  bool _isUserInput(String s) {
    return _digitOnlyRegex.firstMatch(s) != null;
  }
}

///
/// An abstract class extends from [TextInputFormatter] and does numeric filter.
/// It has an abstract method `_format()` that lets its children override it to
/// format input displayed on [TextField]
///
abstract class NumberInputFormatter extends TextInputFormatter {
  TextEditingValue? _lastNewValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    /// nothing changes, nothing to do
    if (newValue.text == _lastNewValue?.text) {
      return newValue;
    }
    _lastNewValue = newValue;

    /// remove all invalid characters
    newValue = _formatValue(oldValue, newValue);

    /// current selection
    int selectionIndex = newValue.selection.end;

    /// format original string, this step would add some separator
    /// characters to original string
    final newText = _formatPattern(newValue.text);

    /// count number of inserted character in new string
    int insertCount = 0;

    /// count number of original input character in new string
    int inputCount = 0;
    for (int i = 0; i < newText!.length && inputCount < selectionIndex; i++) {
      final character = newText[i];
      if (_isUserInput(character)) {
        inputCount++;
      } else {
        insertCount++;
      }
    }

    /// adjust selection according to number of inserted characters staying before
    /// selection
    selectionIndex += insertCount;
    selectionIndex = min(selectionIndex, newText.length);

    /// if selection is right after an inserted character, it should be moved
    /// backward, this adjustment prevents an issue that user cannot delete
    /// characters when cursor stands right after inserted characters
    if (selectionIndex - 1 >= 0 &&
        selectionIndex - 1 < newText.length &&
        !_isUserInput(newText[selectionIndex - 1])) {
      selectionIndex--;
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
      composing: TextRange.empty,
    );
  }

  /// check character from user input or being inserted by pattern formatter
  bool _isUserInput(String s);

  /// format user input with pattern formatter
  String? _formatPattern(String digits);

  /// validate user input
  TextEditingValue _formatValue(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  );
}

class DecimalFormatter extends TextInputFormatter {
  final int decimalDigits;

  DecimalFormatter({this.decimalDigits = 3}) : assert(decimalDigits >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText;
    String lastChar = '';
    String preLastChar = '';
    // print('newValue = ${newValue.text}');
    List<String> list = [];
    if (newValue.text.isNotEmpty) {
      list = newValue.text.split('.');
      if (newValue.text.length > 0) {
        lastChar = newValue.text.lastChars(1);
      }
      if (newValue.text.length > 1) {
        preLastChar = newValue.text.lastChars(2).firstChars(1);
      }
      // print('lastChar = $lastChar ; preLastChar = $preLastChar');
      if (lastChar == ',') {
        lastChar = '.';
        newText = newValue.text.replaceFirst(
          RegExp(','),
          '.',
          newValue.text.length - 1,
        );
      } else {
        newText = newValue.text;
      }
    } else {
      newText = newValue.text;
    }

    if (decimalDigits == 0) {
      newText = newText.replaceAll(RegExp('[^0-9]'), '');
    } else {
      newText = newText.replaceAll(RegExp('[^0-9\.]'), '');
    }
    print('newText = $newText');
    if (newText.contains('.')) {
      //in case if user's first input is "."
      if (newText.trim() == '.') {
        // print('xxx');
        return newValue.copyWith(
          text: '0.',
          selection: TextSelection.collapsed(offset: 2),
        );
      }
      //in case if user tries to input multiple "."s or tries to input
      //more than the decimal place
      else if ((newText.split(".").length > 2) ||
          (newText.split(".")[1].length > this.decimalDigits)) {
        // print('oldValue = $oldValue');
        return oldValue;
      } else {
        double newDouble = double.parse(newText);

        String format = '###,###.##';
        switch (decimalDigits) {
          case 0:
          case 1:
          case 2:
            format = '###,###.##';
            break;
          case 3:
            format = '###,###.###';
            break;
          case 4:
            format = '###,###.####';
            break;
          case 5:
            format = '###,###.#####';
            break;
        }
        String newString = NumberFormat(format, 'en_US').format(newDouble);

        // print('newString from double = $newString');
        // print(list);
        // print(list.length == 2 && double.tryParse(list[1]) == 0);
        if (list.length == 2 && double.tryParse(list[1]) == 0) {
          newString += '.' + list[1];
        }

        if (lastChar == '.') {
          if (preLastChar == '.') {
            newString += preLastChar + lastChar;
          } else {
            newString += lastChar;
          }
        }
        // print('newString = $newString');

        return newValue.copyWith(
          text: newString,
          selection: TextSelection.collapsed(offset: newString.length),
        );
      }
    }

    //in case if input is empty or zero
    if (newText.trim() == '' || newText.trim() == '0') {
      return newValue.copyWith(text: '');
    } else if (int.parse(newText) < 1) {
      return newValue.copyWith(text: '');
    }

    double newDouble = double.parse(newText);

    String format = '###,###.0#';
    switch (decimalDigits) {
      case 0:
      case 1:
      case 2:
        format = '###,###.##';
        break;
      case 3:
        format = '###,###.###';
        break;
      case 4:
        format = '###,###.####';
        break;
      case 5:
        format = '###,###.#####';
        break;
    }
    String newString = NumberFormat(format, 'en_US').format(newDouble);

    // return newValue.copyWith(text: newString);
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
