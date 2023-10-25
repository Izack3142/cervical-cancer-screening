import 'package:ccs/app_screens/details_screen.dart';
import 'package:ccs/app_services/user_reply_windows_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleListScreen extends StatefulWidget {
  const PeopleListScreen({super.key});

  @override
  State<PeopleListScreen> createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends State<PeopleListScreen> {
  bool _isLoading = true;
  bool _isDeleting = false;
  int cancer = 0;
  int nocancer = 0;
  List<Map<String, dynamic>> _records = [];
  final _recordsRef = FirebaseFirestore.instance.collection("Patients");

  Future<void> fetchRecords() async {
    await _recordsRef.get().then((value) {
      if (value.docs.isNotEmpty) {
        print("yes data");
        value.docs.forEach((el) {
          _records.add(el.data());
        });
      } else {
        print("no data");
      }
      _records.forEach((el) {
        int index = _records.indexWhere((elem) => elem['id'] == el['id']);
        _records[index]['checked'] = false;
        if (el['result'] == "Cancer") {
          cancer++;
        }
        if (el['result'] == "No cancer") {
          nocancer++;
        }
      });
      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("People"),
        actions: [
          _records.indexWhere((el) => el['checked'] == true) < 0
              ? Container()
              : _isDeleting == true
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Caution"),
                                content: Text(
                                    "Selected record(s) will be deleted parmanently."),
                                actions: [
                                  OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                  ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        setState(() {
                                          _isDeleting = true;
                                        });
                                        for (var el in _records) {
                                          if (el['checked'] == true) {
                                            await _recordsRef
                                                .doc(el['id'])
                                                .delete();
                                          }
                                        }
                                        setState(() {
                                          _isDeleting = false;
                                          _isLoading = true;
                                          _records = [];
                                          cancer = 0;
                                          nocancer = 0;
                                          fetchRecords();
                                        });
                                      },
                                      child: Text("Proceed"))
                                ],
                              );
                            });
                      },
                      icon: Icon(Icons.delete))
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _records.isEmpty
              ? Center(
                  child: Text("No records yet.."),
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Total: ${_records.length}"),
                        Text("Cancer: ${cancer}"),
                        Text("No cancer: ${nocancer}"),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: _records.length,
                          itemBuilder: (context, ind) {
                            var data = _records[ind];
                            return ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -3, vertical: -3),
                              leading: const Icon(Icons.person),
                              contentPadding: EdgeInsets.all(0),
                              title: Text(data['name']),
                              subtitle: Text(data['result']),
                              onTap: () {
                                UserReplyWindows().navigateScreen(
                                    context, DetailsScreen(data), false);
                              },
                              trailing: Checkbox(
                                  value: data['checked'],
                                  onChanged: (val) {
                                    setState(() {
                                      data['checked'] = val;
                                    });
                                  }),
                            );
                            // Container(
                            //   decoration: BoxDecoration(
                            //       border: Border(bottom: BorderSide())),
                            //   child: ListTile(
                            //       onTap: () {
                            //         UserReplyWindows().navigateScreen(
                            //             context, DetailsScreen(data), false);
                            //       },
                            //       visualDensity: VisualDensity(
                            //           horizontal: -4, vertical: -4),
                            //       contentPadding: EdgeInsets.only(left: 2),
                            //       //dense: true,
                            //       leading: const Icon(Icons.person),
                            //       title: Text(data['name']),
                            //       subtitle: Text(data['result'])),
                            // );
                          }),
                    ),
                  ],
                ),
    );
  }
}
