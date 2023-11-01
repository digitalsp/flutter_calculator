import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Material3対応のためDymamicColorBuilderでMaterial Appをラップ
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        title: 'Calculator App',
        theme: lightTheme(lightDynamic),
        darkTheme: darkTheme(darkDynamic),
        home: Calculator(),
      );
    });
  }
}

//Material You(Material3)の対応にMaterial3非対応端末向けのColorScheme設定メソッド
ThemeData lightTheme(ColorScheme? lightColorScheme) {
  final scheme = lightColorScheme ??
      ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 93, 137, 239));
  return ThemeData(
    colorScheme: scheme,
    textTheme: GoogleFonts.mPlusRounded1cTextTheme().copyWith(
      //Theme.of(context).textTheme,
      bodyMedium: const TextStyle( // ダークテーマの通常のテキスト
        color: Colors.black, // テキストの色を白に変更
      ),
      displayMedium: const TextStyle( // ダークテーマのタイトル
        color: Colors.black87, // タイトルの色を真っ白に変更
      ),
    ),
  );
}

ThemeData darkTheme(ColorScheme? darkColorScheme) {
  final scheme = darkColorScheme ??
      ColorScheme.fromSeed(
        seedColor: Color.fromARGB(255, 93, 137, 239),
        brightness: Brightness.dark,
      );
  return ThemeData(
    colorScheme: scheme,
    textTheme: GoogleFonts.mPlusRounded1cTextTheme().copyWith(
      //Theme.of(context).textTheme,
      bodyMedium: const TextStyle( // ダークテーマの通常のテキスト
        color: Colors.white, // テキストの色を白に変更
      ),
      displayMedium: const TextStyle( // ダークテーマのタイトル
        color: Colors.white70, // タイトルの色を真っ白に変更
      ),
    ),
  );
}

//ColorScheme設定メソッドここまで、調べてたけどMaterial3非対応端末を持ってないから動くか不明

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _expression = '';
  String _result = '';

  void _updateExpression(String value) {
    setState(() {
      // 「÷」を「/」に置換
      value = value.replaceAll('÷', '/');
      // 「*」を「×」に置換
      value = value.replaceAll('×', '*');

      if (value == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          _result = exp.evaluate(EvaluationType.REAL, cm).toString();
        } catch (e) {
          _result = 'Error';
        }
      } else if (value == 'C') {
        _expression = '';
        _result = '';
      } else {
        _expression += value;
      }
    });
  }

  Widget _buildButton(String label) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            //角を丸くしない
            borderRadius: BorderRadius.circular(0),
          ),
          // ボタンの高さを画面サイズから計算
          minimumSize: Size(((MediaQuery.of(context).size.width / 6) - 10),
              ((MediaQuery.of(context).size.height / 6) - 10)),
          //枠線
          side: BorderSide(
            color: Colors.black54,
            width: 0.5,
          ),
        ),
        onPressed: () {
          _updateExpression(label);
        },
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 36),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
      ),
      body: Column(
        //中央寄せ
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    //右下にテキスト配置
                    alignment: Alignment.bottomRight,
                    //Padding
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 5,
                      right: 30,
                    ),
                    child: Text(
                      _expression,
                      style: TextStyle(
                        fontSize: 32,
                        //color: Colors.white,
                        ),
                    ),
                  ),
                ),
                //横線引く
                Divider(
                  thickness: 1,
                  height: 0,
                  indent: 30,
                  endIndent: 30,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    //中央右寄せ
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(
                      right: 30.0,
                      //top: 10.0,
                      ),
                    child: Text(
                      '= $_result',
                      style: TextStyle(
                        fontSize: 48,
                        //color: Colors.white
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ボタン部分
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 数字キーの行
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['7', '8', '9', '÷']
                      .map((label) => _buildButton(label))
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['4', '5', '6', '×']
                      .map((label) => _buildButton(label))
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['1', '2', '3', '-']
                      .map((label) => _buildButton(label))
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['0', 'C', '.', '+']
                      .map((label) => _buildButton(label))
                      .toList(),
                ),
                // = ボタン
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      _updateExpression('=');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        //角を丸くしない
                        borderRadius: BorderRadius.circular(0),
                      ),
                      // ボタンの高さを画面サイズから計算
                      minimumSize: Size(double.infinity,
                          MediaQuery.of(context).size.height / 5),
                      //枠線
                      side: BorderSide(
                        color: Colors.black54,
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '=',
                        style: TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
