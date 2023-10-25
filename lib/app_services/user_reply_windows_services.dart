import 'package:ccs/app_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ccs/app_services/common_variables.dart';
import 'package:http/http.dart' as http;
import 'package:ccs/main.dart';

class UserReplyWindows{
  
   Future<void> checkForAccess(BuildContext context)async{
    final url=Uri(scheme: "https",host: "cervicalcancer.pythonanywhere.com",path: "/model");

      await http.get(url).then((response){
        print(response.body);
        if(response.body=="granted"){ 
            UserReplyWindows().navigateScreen(context, HomeScreen(),true);
        } 
        if(response.body=="denied"){
              showDialog(context: context,
               builder: (context){
                 return AlertDialog(
                  title:Text("Alert") ,      
                  content: Text("Connection closed temporarly.."),
                 );        
               });
        }
        }).catchError((e){
        Navigator.pop(context);
        UserReplyWindows().showSnackBar(e.toString(),"error"); 
      });
   }

   Future<Map<String,dynamic>> checkDatabaseStatus()async{
    Map<String,dynamic> result={};
    String connString="mongodb+srv://isiakamfugale:FzjAva3NHgdUXy9m@cluster0.c9hwoye.mongodb.net/Connection?retryWrites=true&w=majority";
    try{
    await Db.create(connString).then((db)async{
      final collection= db.collection("Hook");
      
     await collection.insert({"name":"Isiaka"}).then((value){
      print(" Data");
          if(value.isNotEmpty){
             result={'msg':"found"};
          }else{
             result={'msg':"not-found"};
          }
      }).catchError((e){
       result={'msg':e.toString()};
    });
    }).catchError((e){
       result={'msg':e.toString()};
    }); 
   }catch (e) {
      result={'msg':e.toString()};
   }
    return result;
   }


  navigateScreen(BuildContext context,Widget newScreen,bool kill){
   if(kill==true){
     Navigator.pushReplacement(context, PageTransition(child: newScreen, type: PageTransitionType.rightToLeft));
   }else{
      Navigator.push(context, PageTransition(child: newScreen, type: PageTransitionType.rightToLeft));
   } 
   
  }

 showSnackBar(String message,String type){
  scaffoldKey.currentState!.showSnackBar(SnackBar(
    backgroundColor: type=="error"?Colors.red:Colors.green,
    duration: Duration(seconds:3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    content:Row(
    children: [
      Icon(type=="error"?Icons.error:Icons.done),
      Expanded(child: Text(message,style: TextStyle(fontWeight: FontWeight.bold),)),
    ],
  )));
 }


  void showLoadingDialog(BuildContext context){
    showDialog(context: context,
    barrierColor: Colors.black87,
     builder: (context){
       return AlertDialog(
         backgroundColor: whiteColor,
         contentPadding: EdgeInsets.all(5),
          content: Container(
        //width: 50,height:50,
        
        padding: EdgeInsets.all(0),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
           children:[
             Text("PREPARING RESULTS",style: TextStyle(fontWeight: FontWeight.bold),),
             SizedBox(height: 5,),
             SpinKitCircle(color: appColor),
             Text("please wait..",style: TextStyle(fontWeight: FontWeight.bold),)
             ],
         ),
       )
       );
        });
  }
}