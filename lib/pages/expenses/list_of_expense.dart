import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ListExpenses extends StatefulWidget {
  const ListExpenses({Key? key}) : super(key: key);

  @override
  State<ListExpenses> createState() => _ListExpensesState();
}

class _ListExpensesState extends State<ListExpenses> {
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
        title: Text('List of Expenses'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('expenses').doc(uid).collection('expense').snapshots(),
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
                                        child: Text(documentSnapshot.get('date'),style:TextStyle(fontSize: 16,color: Colors.white),),
                                      ),
                                      SizedBox(height: 5,),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(documentSnapshot.get('desc'),style:TextStyle(fontSize: 16,color: Colors.white),),
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
        ),
      ),
    );
  }
}
