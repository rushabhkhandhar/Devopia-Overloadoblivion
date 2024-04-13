import 'package:devopia_overload_oblivion/screens/quiz_play.dart';
import 'package:flutter/material.dart';
import 'package:devopia_overload_oblivion/screens/chat_help1.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Results extends StatefulWidget {
  final int total, correct, incorrect, notattempted;
  final List<Map<String,dynamic>> questions;
  Results({required this.incorrect,required this.total,required this.correct,required this.notattempted,required this.questions});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${widget.correct}/ ${widget.total}", style: TextStyle(fontSize: 25),),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "You answered ${widget.correct} answers correctly and ${widget.incorrect} answers incorrectly",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24,),
              SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: <ChartData>[
                      ChartData('Correct', widget.correct),
                      ChartData('Incorrect', widget.incorrect),
                      ChartData('Not Attempted', widget.notattempted),
                    ],
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                  ),
                ],
              ),
              SizedBox(height: 24,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Go to home", style: TextStyle(color: Colors.white, fontSize: 19),),
                ),
              ),
              SizedBox(height: 16,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatLoadScreen(questions: questions,)));
                },
                child: Text('Need for improvements?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
      ),
      body: Center(
        child: Text('This is the next screen'),
      ),
    );
  }
}