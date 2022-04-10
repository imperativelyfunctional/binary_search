import 'dart:math';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: const BubbleSort(),
  ));
}

class BubbleSort extends StatefulWidget {
  const BubbleSort({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BubbleSortWidget();
  }
}

const defaultBackgroundColor = Color(0xFFFFFFFF);
const highlightedBackgroundColor = Color(0xFFA9E4F3);
const completedBackgroundColor = Color(0xFF9EEC50);
const defaultTextColor = Colors.deepPurple;
const completedTextColor = Colors.orange;
const answerBackgroundColor = Colors.orange;

class _BubbleSortWidget extends State<BubbleSort> {
  static const int maxInt = 1000;
  final controller = TextEditingController();

  final List<CellModel> numbers = List.generate(
      8,
      (index) => CellModel(
          number: Random().nextInt(maxInt),
          backgroundColor: defaultBackgroundColor,
          textColor: defaultTextColor))
    ..sort();

  @override
  Widget build(BuildContext context) {
    var unit = (MediaQuery.of(context).size.width - 70) / 8;
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 20),
            children: [
              TextSpan(
                  text: '轻松搞懂数据结构和算法',
                  style: GoogleFonts.zcoolKuaiLe(color: Colors.yellowAccent)),
              TextSpan(
                  text: '【',
                  style:
                      GoogleFonts.zcoolKuaiLe(color: Colors.deepOrangeAccent)),
              TextSpan(
                  text: '搜尋系列',
                  style: GoogleFonts.zcoolKuaiLe(color: Colors.blue)),
              TextSpan(
                  text: '】',
                  style:
                      GoogleFonts.zcoolKuaiLe(color: Colors.deepOrangeAccent))
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 40,
            crossAxisSpacing: 0.5,
            mainAxisSpacing: 0.5,
          ),
          itemCount: 5000,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white70,
            );
          },
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'Binary Search - 二分搜尋法',
                    style: GoogleFonts.actor(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.orange),
                  )),
              ConstrainedBox(
                  constraints: BoxConstraints(minHeight: unit, maxHeight: unit),
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: numbers.length,
                      itemBuilder: (context, index) {
                        var cell = numbers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ClayContainer(
                            emboss: false,
                            color: cell.backgroundColor,
                            height: unit,
                            width: unit,
                            child: Center(
                              child: FittedBox(
                                child: ClayText(cell.number.toString(),
                                    emboss: true, color: cell.textColor),
                              ),
                            ),
                          ),
                        );
                      })),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          for (var i = 0; i < 8; i++) {
                            numbers[i] = CellModel(
                                number: Random().nextInt(maxInt),
                                backgroundColor: defaultBackgroundColor,
                                textColor: defaultTextColor);
                          }
                          setState(() {
                            numbers.sort();
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.lightGreen),
                        ),
                        child: const Text('隨機生成數字')),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          isDense: true,
                          counterText: '',
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintStyle: TextStyle(fontSize: 12),
                          hintText: '查詢數字',
                        ),
                        maxLength: 3,
                        controller: controller,
                      ),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () async {
                          int left = 0;
                          int right = numbers.length - 1;
                          var target = int.parse(controller.text);
                          var index = -1;
                          while (left <= right) {
                            await Future.delayed(
                                const Duration(milliseconds: 2000), () {
                              setState(() {
                                numbers.asMap().forEach((key, value) {
                                  if (key < left || key > right) {
                                    value.backgroundColor =
                                        defaultBackgroundColor;
                                  } else {
                                    value.backgroundColor =
                                        highlightedBackgroundColor;
                                  }
                                });
                              });
                            });

                            int mid = (left + right) ~/ 2;
                            var current = numbers[mid].number;
                            await Future.delayed(
                                const Duration(milliseconds: 1000), () {
                              setState(() {
                                numbers[mid].backgroundColor =
                                    completedBackgroundColor;
                              });
                            });
                            if (current > target) {
                              right = mid - 1;
                            } else if (current < target) {
                              left = mid + 1;
                            } else {
                              index = mid;
                              break;
                            }
                          }
                          if (index == -1) {
                            for (var element in numbers) {
                              element.backgroundColor = defaultBackgroundColor;
                            }
                          } else {
                            await Future.delayed(
                                const Duration(milliseconds: 1000), () {
                              setState(() {
                                numbers[index].backgroundColor =
                                    answerBackgroundColor;
                              });
                            });
                          }
                        },
                        child: const Text('展示排序演示'))
                  ],
                ),
              ),
              TeXView(
                  child: _teXViewWidget(
                      r"<h4>Run time complexity</h4>", r"""<p>    
              <center> <h3>操作次數</h3></center>
             $$ \frac{𝑛}{2^1}|\frac{𝑛}{2^2}|\frac{𝑛}{2^3}|...|\frac{𝑛}{2^k}  $$ <br>
             $$  由於\frac{𝑛}{2^k}=1 所以 k=log(n) $$ <br>
        <table width="100%">
          <td>
               <center><h3>算法運行時間</h3></center>
    <center>$$ O(log(n)) $$</center><br>
          </td>
                    <td>
               <center><h3>空間複雜度</h3></center>
    <center>$$ O(1) $$</center><br>
          </td>
        </table>
    </p>"""))
            ],
          ),
        ),
      ]),
    );
  }
}

TeXViewWidget _teXViewWidget(String title, String body) {
  return TeXViewColumn(
      style: const TeXViewStyle(
          margin: TeXViewMargin.all(5),
          padding: TeXViewPadding.all(5),
          borderRadius: TeXViewBorderRadius.all(5),
          border: TeXViewBorder.all(TeXViewBorderDecoration(
              borderWidth: 2,
              borderStyle: TeXViewBorderStyle.groove,
              borderColor: Colors.green))),
      children: [
        TeXViewDocument(title,
            style: const TeXViewStyle(
                padding: TeXViewPadding.all(5),
                borderRadius: TeXViewBorderRadius.all(5),
                textAlign: TeXViewTextAlign.center,
                width: 250,
                margin: TeXViewMargin.zeroAuto(),
                backgroundColor: Colors.amber)),
        TeXViewDocument(body,
            style: const TeXViewStyle(margin: TeXViewMargin.only(top: 10)))
      ]);
}

extension Search on List<int> {
  int binarySearch(List<int> numbers, int target) {
    int left = 0;
    int right = numbers.length - 1;
    while (left <= right) {
      int mid = (left + right) ~/ 2;
      var current = numbers[mid];
      if (current > target) {
        right = mid - 1;
      } else if (current < target) {
        left = mid + 1;
      } else {
        return mid;
      }
    }
    return -1;
  }
}

class CellModel extends Comparable<CellModel> {
  int number;
  Color backgroundColor;
  Color textColor;

  CellModel(
      {required this.number,
      required this.backgroundColor,
      required this.textColor});

  @override
  int compareTo(other) {
    return number - other.number;
  }
}
