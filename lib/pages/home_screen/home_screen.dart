import 'package:account_management_system/auth/auth_screen.dart';
import 'package:account_management_system/pages/account_receiveable/accounts_receiveable.dart';
import 'package:account_management_system/pages/accounts_payble/accounts_payble.dart';
import 'package:account_management_system/pages/cash_in_hand.dart';
import 'package:account_management_system/pages/expenses/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String?uid;
  @override
  void initState() {
    getUid();
    super.initState();
  }
  getUid()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final firebaseUser = await auth.currentUser;
    setState(() {
      uid = firebaseUser?.uid;
    });
  }
 List<String> choices = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Manager'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AuthScreen()), (route) => false);
          },
              icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 8.0,
          ),
          children: [
            GestureDetector(onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountsReceiveable()));
            },child: Container(decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(12)),child: Center(child: Text('Accounts\nReceivable',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)),)),
            GestureDetector(onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountsPaybles()));
            },child: Container(decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(12)),child: Center(child: Text('Accounts\nPayable',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)),)),
            GestureDetector(onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CashInHand()));
            },child: Container(decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(12)),child: Center(child: Text('Cash In\nHand',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)),)),
            GestureDetector(onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Expense()));
            },child: Container(decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(12)),child: Center(child: Text('Expenses',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),textAlign: TextAlign.center,)),)),
            ]
        ),
      )
    );
  }
}
