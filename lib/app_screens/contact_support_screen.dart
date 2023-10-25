import 'package:ccs/app_services/user_reply_windows_services.dart';
import 'package:flutter/material.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
 final _emailTxtController=TextEditingController();
 final _messageTxtController=TextEditingController();
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact support"),),
      body: Padding(padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Text("For any issue please contact us via this form",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
        Text("A human service provide will followup soon",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 12)),
        SizedBox(height: 10,),
        SizedBox(
          height: 45,
          child: TextField(
            maxLines: 1,
            controller: _emailTxtController,
            decoration: InputDecoration(
              label: Text("Your email address"),
              border: OutlineInputBorder()
            ),
          ),
        ),
        SizedBox(height: 5,),
        TextField(
            maxLines: 6,
            controller: _emailTxtController,
            decoration: InputDecoration(
              label: Text("Explain your issue here"),
              border: OutlineInputBorder()
            ),
          ),
          ElevatedButton(onPressed: ()async{
              setState(() {
                _isLoading=true;
                });
            Future.delayed(Duration(milliseconds: 3000),(){
               setState(() {
                 _isLoading=false;
                });
            });
          }, child:_isLoading?CircularProgressIndicator( color: Colors.white,):Text("Submit"))
      ]),
      ),
    );
  }
}