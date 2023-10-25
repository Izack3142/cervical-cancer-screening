import 'dart:async';
//http://127.0.0.1:5000
import 'package:ccs/app_screens/contact_support_screen.dart';
import 'package:ccs/app_screens/login_screen.dart';
import 'package:ccs/app_screens/people_list_screen.dart';
import 'package:ccs/app_screens/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';
import '../app_services/common_variables.dart';
import '../app_services/user_reply_windows_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'analysis_result_screen.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  final _slidingPageController = PageController();
  late SharedPreferences _pref;
  int _currentPage = 0;
  int _slidingPage = 0;
  int _currentSlidingPage = 0;
  var _groupValue = "";
  String _language = "English";
  Timer? _timer;
  List<String> _slidingTexts = [
    "The quickest way for cancer screening",
    "Within few seconds and in few steps",
    "Get useful recommendations that works for you",
  ];
  List<Map<String, dynamic>> questions = [];

  void shiftQuestions() {
    if (_language == "English") {
      questions = [
        {
          "id": 0,
          "answer": null,
          "qn": "What is your gender?",
          "choices": ['male', 'female'],
        },
        {"id": 1, "answer": null, "qn": "How old are you?"},
        {
          "id": 2,
          "answer": null,
          "qn": "How many sexual partners have you been with?"
        },
        {
          "id": 3,
          "answer": null,
          "qn": "At what age did you have your first sexual intercourse?"
        },
        {
          "id": 4,
          "answer": null,
          "qn": "How many times have you given birth up to now?"
        },
        {
          "id": 5,
          "answer": null,
          "qn": "Have you ever smoke?",
          "choices": ['yes', 'no'],
          "yesTo": [6, 7]
        },
        {
          "id": 6,
          "answer": null,
          'qn': 'For how many years have you been smoking?'
        },
        {"id": 7, 'qn': 'How many cigarate packets do you smoke per day?'},
        {
          "id": 8,
          "answer": null,
          "qn": "Have you ever been diagnosed with HPV(Human Papilloma Virus)?",
          "choices": ['yes', 'no']
        },
        {
          "id": 9,
          "answer": null,
          "qn": "Have you ever been diagnosed with cervical cancer before?",
          "choices": ['yes', 'no']
        },
        {
          "id": 10,
          "answer": null,
          "qn": "Have you ever been diagnosed with cervical cells?",
          "choices": ['yes', 'no']
        },
        {
          "id": 11,
          "answer": null,
          "qn":
              "Have you undergone citology( pap smear) testing for cervical cancer?",
          "choices": ['yes', 'no']
        },
        {
          "id": 12,
          "answer": null,
          "qn":
              "Have you undergone a biopsy procedures for the diagnosis of cervical cancer?",
          "choices": ['yes', 'no']
        },
      ];
    } else {
      questions = [
        {
          "id": 0,
          "answer": null,
          "qn": "Jinsia yako?",
          "choices": ['mwanaume', 'mwanamke'],
        },
        {"id": 1, "answer": null, "qn": "Una umri gani?"},
        {"id": 2, "answer": null, "qn": "Umewahi kuwa na wapenzi wangapi?"},
        {
          "id": 3,
          "answer": null,
          "qn": "Ulikua na umri gani ulipofanya mapenzi kwa mara ya kwanza?"
        },
        {"id": 4, "answer": null, "qn": "Umejifungua mara ngapi hadi sasa?"},
        {
          "id": 5,
          "answer": null,
          "qn": "Umewahi kuvuta sigara?",
          "choices": ['ndio', 'hapana'],
          "yesTo": [6, 7]
        },
        {"id": 6, "answer": null, 'qn': 'Umevuta sigara kwa miaka mingapi?'},
        {"id": 7, 'qn': 'Paketi ngapi za sigara unavuta kwa siku?'},
        {
          "id": 8,
          "answer": null,
          "qn": " Umewahi kugundulika na virusi vya papilloma ya binadamu?",
          "choices": ['ndio', 'hapana']
        },
        {
          "id": 9,
          "answer": null,
          "qn": "Umewahi kuumwa saratani ya shingo ya kizazi hapo nyuma?",
          "choices": ['ndio', 'hapana']
        },
        {
          "id": 10,
          "answer": null,
          "qn": "Umewahi kugundulika na seli za saratani ya shingo ya kizazi?",
          "choices": ['ndio', 'hapana']
        },
        {
          "id": 11,
          "answer": null,
          "qn":
              "Je umewahi kufanyiwa uchunguzi wa citology kwaajili ya saratani ya shingo ya kizazi?",
          "choices": ['ndio', 'hapana']
        },
        {
          "id": 12,
          "answer": null,
          "qn":
              "Je umeshafanyiwa upasuaji wa sampuli(biopsy) kwaajili ya uchunguzi wa saratani ya shingo ya kizazi?",
          "choices": ['ndio', 'hapana']
        },
      ];
    }
  }

  Future<void> initPref() async {
    _pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shiftQuestions();
    initPref();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_slidingPage < _slidingTexts.length - 1) {
        _slidingPage++;
        _slidingPageController.animateToPage(_slidingPage,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate);
      } else if (_slidingPage == _slidingTexts.length - 1) {
        _slidingPage = 0;
        _slidingPageController.animateToPage(_slidingPage,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appColor,
      appBar: AppBar(
        elevation: 1,
        title: const Text("CCS"),
        actions: [
          Column(
            children: [
              Expanded(child: Container()),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        _currentPage = 0;
                        _pageController.animateToPage(_currentPage,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.decelerate);
                        if (_language == "English") {
                          _language = "Kiswahili";
                        } else {
                          _language = "English";
                        }
                      });
                      shiftQuestions();
                      await _pref.setString('language', _language);
                    },
                    child: AbsorbPointer(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(40)),
                        child: Text(_language,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        UserReplyWindows()
                            .navigateScreen(context, LoginScreen(), false);
                      },
                      icon: Icon(Icons.login))
                ],
              ),
              Expanded(child: Container())
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenSize.height * 0.03,
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(200)),
                    child: Image.asset("assets/images/app_icon.png"),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Results are backedup by an AI trained by A TEAM OF professional doctors"
                          .toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          color: whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Answer questions to get Analysed",
                style: TextStyle(fontSize: 17, color: whiteColor),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: PageView.builder(
                        controller: _slidingPageController,
                        itemCount: _slidingTexts.length,
                        itemBuilder: (context, index) {
                          var text = _slidingTexts[index];
                          return Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: Colors.blue, width: 4))),
                              child: Text(text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white)),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 130,
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: questions.length,
                        physics: NeverScrollableScrollPhysics(),
                        onPageChanged: (newPage) {
                          // setState((){
                          //   _currentPage=newPage;
                          // });
                          // _pageController.animateToPage(_currentPage, duration:const Duration(milliseconds:500), curve: Curves.decelerate);
                          // _groupValue="";
                        },
                        itemBuilder: (context, index) {
                          var qn = questions[index];
                          final txtController = TextEditingController();
                          return Container(
                            color: Colors.black38,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: ShowUpAnimation(
                                        animationDuration:
                                            Duration(milliseconds: 500),
                                        child: Text(
                                          qn['qn'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: whiteColor,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                ShowUpAnimation(
                                  animationDuration:
                                      Duration(milliseconds: 500),
                                  child: qn['choices'] == null
                                      ? Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: TextField(
                                            controller: txtController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onChanged: (val) {
                                              questions[_currentPage]
                                                  ["answer"] = val;
                                              print(questions[_currentPage]
                                                  .toString());
                                            },
                                            decoration: InputDecoration(
                                                hintText: "Your answer here",
                                                border: OutlineInputBorder()),
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: StatefulBuilder(
                                              builder: (context, stateSetter) {
                                            return Column(
                                              children: (qn['choices']
                                                      as List<String>)
                                                  .map((choice) {
                                                return RadioListTile(
                                                    dense: true,
                                                    visualDensity:
                                                        VisualDensity(
                                                            horizontal: -3,
                                                            vertical: -3),
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 5),
                                                    value: choice,
                                                    title: Text(choice,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    groupValue: _groupValue,
                                                    onChanged: (va) {
                                                      stateSetter(() {
                                                        _groupValue = va!;
                                                        //print(_currentPage);
                                                        questions[_currentPage]
                                                                ["answer"] =
                                                            (questions[_currentPage]
                                                                        [
                                                                        "choices"]
                                                                    as List<
                                                                        String>)
                                                                .indexWhere(
                                                                    (e) =>
                                                                        e ==
                                                                        va);
                                                      });
                                                    });
                                              }).toList(),
                                            );
                                          }),
                                        ),
                                ),
                                SizedBox(
                                  height: 5,
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              )),
              Row(
                children: [
                  FloatingActionButton(
                      onPressed: () {
                        _pageController.jumpToPage(0);
                        setState(() {
                          _currentPage = 0;
                        });
                        questions.forEach((el) {
                          el['answer'] = null;
                        });
                      },
                      backgroundColor: Colors.black38,
                      child: Icon(Icons.home),
                      mini: true),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FloatingActionButton(
                          heroTag: "2",
                          mini: true,
                          onPressed: () {
                            print(_currentPage);
                            if (questions[5]['answer'] == 0) {
                              questions[_currentPage - 1]['answer'] = null;
                              questions[_currentPage]['answer'] = null;
                              _currentPage = _currentPage - 1;
                              setState(() {});
                              _pageController.animateToPage(_currentPage,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.decelerate);
                            } else {
                              if (_currentPage > 5 &&
                                  _currentPage <= 8 &&
                                  questions[5]['answer'] == 1) {
                                questions[_currentPage - 1]['answer'] = null;
                                questions[_currentPage]['answer'] = null;
                                _currentPage = 5;
                                setState(() {});
                                _pageController.animateToPage(_currentPage,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.decelerate);
                              } else {
                                questions[_currentPage - 1]['answer'] = null;
                                questions[_currentPage]['answer'] = null;
                                _currentPage = _currentPage - 1;
                                setState(() {});
                                _pageController.animateToPage(_currentPage,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.decelerate);
                              }
                            }
                          },
                          child: Icon(
                            Icons.arrow_left_sharp,
                            size: 45,
                          ),
                          backgroundColor: Colors.black38),
                    ),
                  ),
                  Text("${_currentPage + 1}/${questions.length}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: whiteColor)),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                          heroTag: "1",
                          mini: true,
                          onPressed: () {
                            print(_currentPage);
                            if (questions[_currentPage]['answer'] != null) {
                              if (_currentPage == questions.length - 1) {
                                print(questions.length);
                                UserReplyWindows().navigateScreen(
                                    context, PreviewScreen(questions), false);
                              } else {
                                if (_currentPage == 0 &&
                                    questions[_currentPage]['answer'] == 0) {
                                  UserReplyWindows().showSnackBar(
                                      "Sorry!! cervical cancer involve females only",
                                      "error");
                                } else {
                                  if (questions[_currentPage]['choices'] ==
                                      null) {
                                    switch (_currentPage) {
                                      case 1:
                                        if (int.parse(questions[_currentPage]
                                                    ['answer']) <
                                                100 &&
                                            int.parse(questions[_currentPage]
                                                    ['answer']) >
                                                0) {
                                          String condition = "";
                                          setState(() {
                                            _groupValue = "";
                                            _currentPage = _currentPage + 1;
                                            _pageController.animateToPage(
                                                _currentPage,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.decelerate);
                                          });
                                        } else {
                                          UserReplyWindows().showSnackBar(
                                              "Invalid human age..", "error");
                                        }
                                        break;
                                      case 3:
                                        if (int.parse(questions[_currentPage]
                                                ['answer']) <=
                                            int.parse(questions[1]['answer'])) {
                                          String condition = "";
                                          setState(() {
                                            _groupValue = "";
                                            _currentPage = _currentPage + 1;
                                            _pageController.animateToPage(
                                                _currentPage,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.decelerate);
                                          });
                                        } else {
                                          UserReplyWindows().showSnackBar(
                                              "Can't exceed your age..",
                                              "error");
                                        }
                                        break;
                                      case 4:
                                        if ((int.parse(questions[1]['answer']) <
                                                    9 &&
                                                int.parse(
                                                        questions[_currentPage]
                                                            ['answer']) ==
                                                    0) ||
                                            (int.parse(questions[1]['answer']) >
                                                    9 &&
                                                int.parse(
                                                        questions[_currentPage]
                                                            ['answer']) >=
                                                    0)) {
                                          String condition = "";
                                          setState(() {
                                            _groupValue = "";
                                            _currentPage = _currentPage + 1;
                                            _pageController.animateToPage(
                                                _currentPage,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.decelerate);
                                          });
                                        } else {
                                          UserReplyWindows().showSnackBar(
                                              "Invalid age for giving birth..",
                                              "error");
                                        }
                                        break;
                                      default:
                                        if (questions[_currentPage]['id'] ==
                                                7 &&
                                            int.parse(questions[_currentPage]
                                                    ['answer']) >
                                                10) {
                                          UserReplyWindows().showSnackBar(
                                              "Invalid number of packets per day..",
                                              "error");
                                        } else {
                                          String condition = "";
                                          setState(() {
                                            _groupValue = "";
                                            _currentPage = _currentPage + 1;
                                            _pageController.animateToPage(
                                                _currentPage,
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.decelerate);
                                          });
                                        }
                                    }
                                  } else {
                                    if (_currentPage == 5 &&
                                        questions[_currentPage]['answer'] ==
                                            1) {
                                      String condition = "";
                                      setState(() {
                                        _groupValue = "";
                                        _currentPage = 8;
                                        _pageController.animateToPage(
                                            _currentPage,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.decelerate);
                                      });
                                    } else {
                                      String condition = "";
                                      setState(() {
                                        _groupValue = "";
                                        _currentPage = _currentPage + 1;
                                        _pageController.animateToPage(
                                            _currentPage,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.decelerate);
                                      });
                                    }
                                  }
                                }
                              }
                            } else {
                              UserReplyWindows().showSnackBar(
                                  "Please provide an answer", "error");
                            }
                          },
                          child: Icon(
                            Icons.arrow_right_sharp,
                            size: 45,
                          ),
                          backgroundColor: Colors.black38),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComfirmDialog() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'comfirm',
        pageBuilder: (context, anim1, anim2) {
          return AlertDialog(
            title: Text("Comfirm your answers"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 0),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        var qnItem = questions[index];
                        String answer = "";
                        if (qnItem["choices"] == null) {
                          answer = qnItem['answer'].toString();
                        } else {
                          answer =
                              qnItem['choices'][qnItem['answer']].toString();
                        }
                        return Container(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Wrap(
                            spacing: 5,
                            children: [
                              Text(qnItem['qn']),
                              Text(
                                answer,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                ElevatedButton(
                    onPressed: () async {
                      //var uri= Uri.parse("http://192.168.43.171:5000","",data);
                      Map<String, dynamic> qParam = {};
                      for (int i = 1; i < questions.length; i++) {
                        if (questions[i]['choices'] != null) {
                          if (questions[i]['answer'] == 1) {
                            qParam[i.toString()] = "0";
                          }
                          if (questions[i]['answer'] == 0) {
                            qParam[i.toString()] = "1";
                          }
                        } else {
                          qParam[i.toString()] =
                              questions[i]['answer'].toString();
                        }
                      }
                      print(qParam);
                      final url = Uri(
                          scheme: "https",
                          host: "cervicalcancer.pythonanywhere.com",
                          queryParameters: qParam);
                      print(url.toString());
                      UserReplyWindows().showLoadingDialog(context);
                      await http.get(url).then((response) {
                        Navigator.pop(context);
                        UserReplyWindows().navigateScreen(context,
                            AnalysisResultScreen(response.body), false);
                      }).catchError((e) {
                        Navigator.pop(context);
                        UserReplyWindows().showSnackBar(e.toString(), "error");
                      });
                    },
                    child: Text("Submit"))
              ],
            ),
          );
        });
  }
}
