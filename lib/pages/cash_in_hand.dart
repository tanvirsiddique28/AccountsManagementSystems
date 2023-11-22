import 'package:account_management_system/widgets/customeTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/flutter_toast.dart';
import '../widgets/buttons.dart';
class CashInHand extends StatefulWidget {
  const CashInHand({Key? key}) : super(key: key);

  @override
  State<CashInHand> createState() => _CashInHandState();
}

class _CashInHandState extends State<CashInHand> {
  TextEditingController _cashInHandController = TextEditingController();
  TextEditingController _addCashController = TextEditingController();

  String? uid;
  @override
  void initState() {
    getUid();

    super.initState();
  }
  void getUid()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final firebaseResult = await auth.currentUser;
    setState(() {
      uid = firebaseResult?.uid;
      getCash();
    });
  }
  void getCash()async{
    await FirebaseFirestore.instance.collection('cashIn').doc(uid).collection('cash').doc(uid).get().then((value){
      if(value.exists){
        _cashInHandController.text= value.get('cashInHand');
      }else{
        _cashInHandController.text= '0.0';
      }
    });
  }

  void add(){
    double totalCash = double.parse(_cashInHandController.text)+double.parse(_addCashController.text);
    setState(() {
      _cashInHandController.text = totalCash.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash In Hand'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextFormField(
          controller:_cashInHandController,
          decoration: InputDecoration(
              labelText: 'Cash In Hand',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )
          ),
        ),
            SizedBox(height: 10,),
            customsTextFormField('Add Cash', _addCashController),
            SizedBox(height: 10,),
            Buttons(height: 45.0, width: double.infinity, title: 'Add',
                onPress: (){
                  add();
                  saveCash();
                }),
          ],
        ),
      ),
    );
  }
  void saveCash()async{

    if(_addCashController.text.isNotEmpty){
      await FirebaseFirestore.instance.collection('cashIn').doc(uid).collection('cash').doc(uid).set({
        'cashInHand':_cashInHandController.text,
      });
      showToast(message: 'Data Added');
    }else{
      showToast(message: 'Fills up all the fields');
    }
  }
}
