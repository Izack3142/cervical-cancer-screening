import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  var data;
  DetailsScreen(this.data, {super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 0),
            itemCount: widget.data['questions'].length,
            itemBuilder: (context, index) {
              var qnItem = widget.data['questions'][index];
              String answer = "";
              if (qnItem["choices"] == null) {
                int ans = 0;
                if (qnItem["id"] == 7 &&
                    widget.data['questions'][5]['answer'] == 0) {
                  ans = int.parse(qnItem['answer']) * 365;
                  answer = qnItem['answer'].toString() + "(${ans} kwa mwaka)";
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
                      decoration:
                          BoxDecoration(border: Border(bottom: BorderSide())),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            child: Text((index + 1).toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Qn: " + qnItem['qn']),
                                Text(
                                  "Ans: " + answer,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
