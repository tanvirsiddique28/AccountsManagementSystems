import 'package:account_management_system/services/flutter_toast.dart';
import 'package:account_management_system/widgets/buttons.dart';
import 'package:account_management_system/widgets/customeTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'accounts_receiveable.dart';
class PaidReceiveables extends StatefulWidget {
  final String? date,name,amount,phone;
  PaidReceiveables({Key? key,this.date,this.name,this.amount,this.phone}) : super(key: key);

  @override
  State<PaidReceiveables> createState() => _PaidReceiveablesState();
}

class _PaidReceiveablesState extends State<PaidReceiveables> {
  //------controllers-------------
  TextEditingController _dateController =TextEditingController();

  TextEditingController _nameController =TextEditingController();

  TextEditingController _amountController =TextEditingController();

  TextEditingController _phoneController =TextEditingController();

  TextEditingController _addPayController =TextEditingController();
  String? uid;
  @override
  void initState() {
    getUid();
    _dateController.text = widget.date!;
    _nameController.text = widget.name!;
    _amountController.text = widget.amount!;
    _phoneController.text = widget.phone!;
    super.initState();
  }
  void getUid()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final firebaseResult = await auth.currentUser;
    setState(() {
      uid = firebaseResult?.uid;
    });
  }

  void add(){
    if(_addPayController.text.isNotEmpty){
      double add = double.parse(_amountController.text)+double.parse(_addPayController.text);
      _amountController.text = add.toString();
      showToast(message: 'Added');
      updateData();

    }else{
      showToast(message: 'Fills up the field');
    }
  }
  void pay(){
    if(_addPayController.text.isNotEmpty){
      double add = double.parse(_amountController.text)-double.parse(_addPayController.text);
      _amountController.text = add.toString();
      showToast(message: 'Paid');
      updateData();
    }else{
      showToast(message: 'Fills up the field');
    }
  }
  void updateData()async{
    await FirebaseFirestore.instance.collection('receivables').doc(uid).collection('receive').doc(_phoneController.text).set({
      'date':_dateController.text,
      'name':_nameController.text,
      'amount':_amountController.text,
      'phone':_phoneController.text,
    });
  }
  void deleteData()async{
    await FirebaseFirestore.instance.collection('receivables').doc(uid).collection('receive').doc(_phoneController.text).delete();
    showToast(message: 'Deleted');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Add/Pay Receiveables'),
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
            customsTextFormField('Add/Pay', _addPayController),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Buttons(height: 45.0, width: 187.0, title: 'Add',
                    onPress: (){
                  add();
                    }
                ),
                SizedBox(width: 10,),
                Buttons(height: 45.0, width: 187.0, title: 'Pay',
                    onPress: (){
                    pay();
                    }
                )
              ],
            ),
            SizedBox(height: 10,),
            Buttons(height: 45.0, width: double.infinity, title: 'Delete',
                onPress: (){
              deleteData();
                }
            ),
          ],
        ),
      ),
    );
  }
}
