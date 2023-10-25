import 'package:ccs/app_screens/analysis_result_screen.dart';
import 'package:ccs/app_services/user_reply_windows_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PreviewScreen extends StatefulWidget {
  List questions;
  PreviewScreen(this.questions, {super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final _recordsRef = FirebaseFirestore.instance.collection("Patients");
  List questions = [];
  final _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    questions = widget.questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 0),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    var qnItem = questions[index];
                    print(qnItem['answer']);
                    String answer = "";
                    if (qnItem["choices"] == null) {
                      int ans = 0;
                      //nswer = qnItem['answer'].toString();
                      //
                      if (qnItem["id"] == 7 && questions[5]['answer'] == 0) {
                        ans = int.parse(qnItem['answer']) * 365;
                        answer =
                            qnItem['answer'].toString() + "(${ans} kwa mwaka)";
                      } else {
                        answer = qnItem['answer'].toString();
                      }
                    } else {
                      answer = qnItem['choices'][qnItem['answer']].toString();
                    }
                    return qnItem['answer'] == null
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide())),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  child: Text((index + 1).toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13)),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Qn: " + qnItem['qn']),
                                      Text(
                                        "Ans: " + answer,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                  }),
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                    label: Text("Your firstname"),
                    border: OutlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  //var uri= Uri.parse("http://192.168.43.171:5000","",data);
                  if (_textController.text.trim().isNotEmpty) {
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
                        if (questions[i]['id'] == 7 &&
                            questions[5]['answer'] == 0) {
                          qParam[i.toString()] =
                              (int.parse(questions[i]['answer']) * 365)
                                  .toString();
                        } else {
                          qParam[i.toString()] =
                              questions[i]['answer'].toString();
                        }
                      }
                      if (questions[i]['answer'] == null ||
                          questions[i]['answer'].toString().isEmpty) {
                        qParam[i.toString()] = "0";
                      }
                    }
                    int j = 1;
                    print(qParam);
                    Map<String, dynamic> qParam2 = {};
                    qParam.removeWhere((key, value) => key == "5");
                    qParam.forEach((key, value) {
                      qParam2[j.toString()] = value;
                      j++;
                    });
                    print(qParam);
                    print(qParam2);
                    final url = Uri(
                        scheme: "https",
                        host: "cervicalcancer.pythonanywhere.com",
                        queryParameters: qParam2);

                    UserReplyWindows().showLoadingDialog(context);
                    await http.get(url).then((response) async {
                      print(response.body);
                      var id = _recordsRef.doc().id;
                      Map<String, dynamic> data = {};
                      data['questions'] = questions;
                      data['result'] = response.body;
                      data['id'] = id;
                      data['name'] = _textController.text.trim();
                      print(data);
                      await _recordsRef.doc(id).set(data).then((value) {
                        print("done");
                        Navigator.pop(context);
                        UserReplyWindows().navigateScreen(context,
                            AnalysisResultScreen(response.body), false);
                      }).catchError((e) {
                        Navigator.pop(context);
                        UserReplyWindows().showSnackBar(e.code, "error");
                      });
                    });
                  } else {
                    UserReplyWindows()
                        .showSnackBar("Please enter your firstname", "error");
                  }
                },
                child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}
