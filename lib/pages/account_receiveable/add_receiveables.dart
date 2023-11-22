import 'package:account_management_system/pages/account_receiveable/paid_receiveables.dart';
import 'package:account_management_system/services/flutter_toast.dart';
import 'package:account_management_system/services/myCurrentDate.dart';
import 'package:account_management_system/widgets/buttons.dart';
import 'package:account_management_system/widgets/customeTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AddReceiveables extends StatefulWidget {
  const AddReceiveables({Key? key}) : super(key: key);

  @override
  State<AddReceiveables> createState() => _AddReceiveablesState();
}

class _AddReceiveablesState extends State<AddReceiveables> {
  //------controllers-------------
  TextEditingController _dateController =TextEditingController();
  TextEditingController _nameController =TextEditingController();
  TextEditingController _amountController =TextEditingController();
  TextEditingController _phoneController =TextEditingController();
  //-----functions-------
  String? uid;
 @override
  void initState() {
   _dateController.text = MyCurrentDate.myDate();
   getUid();
    super.initState();
  }
  void getUid()async{
   FirebaseAuth auth = FirebaseAuth.instance;
    final firebaseResult = await auth.currentUser;
    setState(() {
      uid = firebaseResult?.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Add Receiveables'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customsTextFormField('Date', _dateController),
            SizedBox(height: 10,),
            customsTextFormField('Name', _nameController),
            SizedBox(height: 10,),
            customsTextFormField('Amount', _amountController),
            SizedBox(height: 10,),
            customsTextFormField('Phone', _phoneController),
            SizedBox(height: 10,),
            Buttons(height: 45.0, width: double.infinity, title: 'Add',
                onPress: (){
                  saveReceivables();
                }
            ),
          ],
        ),
      ),
    );
  }
  void saveReceivables()async{

   if(_nameController.text.isNotEmpty && _amountController.text.isNotEmpty && _phoneController.text.isNotEmpty){
     await FirebaseFirestore.instance.collection('receivables').doc(uid).collection('receive').doc(_phoneController.text).set({
       'date':_dateController.text,
       'name':_nameController.text,
       'amount':_amountController.text,
       'phone':_phoneController.text,
     });
     showToast(message: 'Data Added');
   }else{
     showToast(message: 'Fills up all the fields');
   }
  }
}
