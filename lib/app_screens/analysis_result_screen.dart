import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ccs/app_services/common_variables.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ccs/app_screens/home_screen.dart';

class AnalysisResultScreen extends StatefulWidget {
  String result;
  AnalysisResultScreen(this.result, {super.key});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
    
  late SharedPreferences _pref;
  String _lang = "English";
  double _comfidence = 0.0;
  double _cmfFromModel = 80.6;
  double _startingPoint = 0.0;
  Timer? _timer;

  Future<void> initPref() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _lang = _pref.getString('language')!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPref();
    _startingPoint = _cmfFromModel - _cmfFromModel.toInt();
    _comfidence = _startingPoint;
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_comfidence < _cmfFromModel) {
          _comfidence = _comfidence + 1;
        } else {
          _timer!.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false);
            },
            backgroundColor: Colors.black38,
            child: Icon(Icons.home),
            mini: true),
        backgroundColor: appColor,
        appBar: AppBar(
          elevation: 1,
          title: Text("Results"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Hi there..",
                        style: TextStyle(
                            fontSize: 22,
                            color: whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: Row(
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(200)),
                            child: Image.asset("assets/images/app_icon.png"),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: Text(
                              "I have detected the following based on your prefilled information.",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                )),
            Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(top: 40, left: 10, right: 10),
                  width: screenSize.width,
                  height: screenSize.height,
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      )),
                  child: Column(
                    children: [
                      ShowUpAnimation(
                        delayStart: Duration(milliseconds: 500),
                        direction: Direction.horizontal,
                        child: Container(
                          decoration: BoxDecoration(
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(color: blackColor, blurRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                  color: greyColor,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Text(
                                    "Status",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Text(
                                    widget.result == "Cancer"
                                        ? _lang == "English"
                                            ? "You have cervical cancer"
                                            : "Una saratani ya shingo ya kizazi"
                                        : _lang == "English"
                                            ? "You don't have cervical cancer"
                                            : "Hauna saratani ya shingo ya kizazi",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      ShowUpAnimation(
                        delayStart: Duration(milliseconds: 1500),
                        direction: Direction.horizontal,
                        child: Container(
                          decoration: BoxDecoration(
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(color: blackColor, blurRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                  color: greyColor,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Text(
                                    "Recommendation",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: Text(
                                    widget.result == "Cancer"
                                        ? _lang == "English"
                                            ? "Your condition is not good, consider visiting your nearby health provider for further checkup"
                                            : "Hali yako sio nzuri, Nenda kwa mtaalamu wa afya aliyekaribu kwa vipimo zaidi"
                                        : _lang == "English"
                                            ? "You're safe"
                                            : "Upo salama",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w400),
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ));
  }
}
