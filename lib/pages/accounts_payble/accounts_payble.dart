import 'package:account_management_system/pages/accounts_payble/add_payables.dart';
import 'package:account_management_system/pages/accounts_payble/paid_paybles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AccountsPaybles extends StatefulWidget {
  const AccountsPaybles({Key? key}) : super(key: key);

  @override
  State<AccountsPaybles> createState() => _AccountsPayblesState();
}

class _AccountsPayblesState extends State<AccountsPaybles> {

  //------variables----------
//------variables----------
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

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Paybles'),
        backgroundColor: Colors.green,
      ),
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('paybles').doc(uid).collection('pay').snapshots(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){

                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context,index){
                              DocumentSnapshot  documentSnapshot = snapshot.data!.docs[index];
                              return InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PaidPaybles(
                                    date: documentSnapshot.get('date'),
                                    name: documentSnapshot.get('name'),
                                    amount: documentSnapshot.get('amount'),
                                    phone: documentSnapshot.get('phone'),

                                  )));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade700,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: Text(documentSnapshot.get('name'),style:TextStyle(fontSize: 16,color: Colors.white),),
                                          ),
                                          SizedBox(height: 5,),
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: Text(documentSnapshot.get('date'),style:TextStyle(fontSize: 16,color: Colors.white),),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 20),
                                        child: Text(documentSnapshot.get('amount')+' tk',style:TextStyle(fontSize: 16,color: Colors.white),),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      }else{
                        return CircularProgressIndicator();
                      }
                    }
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPaybles()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
