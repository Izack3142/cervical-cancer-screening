import 'dart:async';
import 'package:ccs/app_screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../app_services/common_variables.dart';
import '../app_services/user_reply_windows_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoWidth=0;
  double _dividerWidth=0;
  Timer? _timer;

 Future<void> checkDatabase()async{
   final res=await UserReplyWindows().checkDatabaseStatus();   
   print(res);
   if(res['msg']=='found'){
       UserReplyWindows().navigateScreen(context, HomeScreen(),true);
   }else{
      if(res['msg']!='not-found'){
        UserReplyWindows().showSnackBar(res['msg'],'error');
      }
   }
 }



 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 2500),()async{
      await UserReplyWindows().checkForAccess(context);
      //UserReplyWindows().navigateScreen(context, HomeScreen(),true);
    });
    _timer=Timer.periodic(Duration(milliseconds: 1000), (timer) { 
          setState(() {
            if(_dividerWidth==60){
              _dividerWidth=5;  
            }else{
              _dividerWidth=60;
            }
         });
         
    });
    Future.delayed(Duration(seconds: 2),(){
         setState(() {
           _logoWidth=150;
         });
    });  
  }

@override
  void dispose() {
    // TODO: implement dispose
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: appColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              width: _logoWidth,
              duration: Duration(seconds: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(200)
              ),
              child: Image.asset("assets/images/app_icon.png"),
            ),
            SizedBox(height: 10,),
            Text("Cervical Cancer Screening",style: TextStyle(fontSize: 25,color:whiteColor,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}