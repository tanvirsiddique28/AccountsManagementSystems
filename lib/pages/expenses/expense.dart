
import 'package:account_management_system/pages/expenses/list_of_expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/flutter_toast.dart';
import '../../services/myCurrentDate.dart';
import '../../widgets/buttons.dart';
import '../../widgets/customeTextField.dart';
class Expense extends StatefulWidget {
  const Expense({Key? key}) : super(key: key);

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  //------controllers-------------
  TextEditingController _cashInHandController =TextEditingController();
  TextEditingController _dateController =TextEditingController();
  TextEditingController _amountController =TextEditingController();
  TextEditingController _descController =TextEditingController();

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
      getCash();
    });
  }
  void getCash()async{
    await FirebaseFirestore.instance.collection('cashIn').doc(uid).collection('cash').doc(uid).get().then((value){
        _cashInHandController.text= value.get('cashInHand');
    });
  }
  void add(){
    double totalCash = double.parse(_cashInHandController.text)-double.parse(_amountController.text);
    setState(() {
      _cashInHandController.text = totalCash.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add Expenses'),
        backgroundColor: Colors.green,
      ),
      body: Container(

        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ Buttons(height: 45.0, width: double.infinity, title: 'List Of Expenses',
              onPress: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ListExpenses()));
              }
          ),SizedBox(height: 30,),
            Container(
              width: double.infinity,
              height: 100,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.blueGrey,
              ),
              child:Center(child: customsTextFormField('Cash In Hand', _cashInHandController)),
            ),
            SizedBox(height: 30,),
            customsTextFormField('Date', _dateController),
            SizedBox(height: 10,),
            customsTextFormField('Amount', _amountController),
            SizedBox(height: 10,),
            customsTextFormField('Description', _descController),
            SizedBox(height: 10,),
            Buttons(height: 45.0, width: double.infinity, title: 'Add',
                onPress: (){
                    add();
                    saveExpense();
                }
            )
          ],
        ),
      ),
    );
  }
  void saveExpense()async{
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    if(_amountController.text.isNotEmpty){
      await FirebaseFirestore.instance.collection('expenses').doc(uid).collection('expense').doc(id).set({
        'date': _dateController.text,
        'amount': _amountController.text,
        'desc': _descController.text,
      });
      showToast(message: 'Data Added');
      await FirebaseFirestore.instance.collection('cashIn').doc(uid).collection('cash').doc(uid).set({
        'cashInHand':_cashInHandController.text,
      });
    }else{
      showToast(message: 'Fills up all the fields');
    }
  }
}
