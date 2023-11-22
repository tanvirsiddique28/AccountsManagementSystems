
import 'package:account_management_system/pages/home_screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  //--------controllers------------------
  TextEditingController _userName = TextEditingController();
  TextEditingController _userEmail = TextEditingController();
  TextEditingController _userPassword = TextEditingController();
  //--------variables-----------------
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = false;
  //--------functions-----------------
  startSignUpAndLogIn(){
    final validity = _formKey.currentState?.validate();

    if(validity!){
      _formKey.currentState?.save();
      submitForm(_userName.text, _userEmail.text, _userPassword.text);
    }
  }
  submitForm(String username,String email,String password,)async{
    FirebaseAuth auth = FirebaseAuth.instance;

    if(_isLogin){
      final authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
    }else{
      final authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
      String?uid = authResult.user?.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {
          "userName":_userName.text,
          "email":_userEmail.text,
        }
      );
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              child: Form(
                key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(30),
                    height: 200,
                    child: Image.asset('assets/accounts.png'),
                  ),
                  SizedBox(height: 10,),
                  if(!_isLogin)
                  TextFormField(
                    controller: _userName,
                    decoration: InputDecoration(
                      labelText: 'Enter Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _userEmail,
                    decoration: InputDecoration(
                      labelText: 'Enter Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _userPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                      onPressed: (){
                        startSignUpAndLogIn();
                      },
                      child:_isLogin? Text('Log In',style: GoogleFonts.roboto(fontSize: 16),):Text('Sign Up',style: GoogleFonts.roboto(fontSize: 16),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 45),
                      ),
                  ),
                  SizedBox(height: 10,),
                  TextButton(onPressed: (){
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                      child: _isLogin?Text('Not a member?',style: GoogleFonts.roboto(color: Colors.black,fontSize: 16),):Text('Already a member?',style: GoogleFonts.roboto(color: Colors.black,fontSize: 16),),
                  )

                ],
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}