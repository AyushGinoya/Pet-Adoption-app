import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption_app/models/user_model.dart';
import 'package:pet_adoption_app/screens/Register/complete_register.dart';
import 'package:pinput/pinput.dart';
import 'package:email_otp/email_otp.dart';

class MyVerify extends StatefulWidget {
  final String email;
  final EmailOTP myAuth;
  final UserModel userModel;
  final User firebaseUser;

  const MyVerify(
      {super.key,
      required this.email,
      required this.myAuth,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  bool loading = false;

  void verifyOtp(String otp) async {
    setState(() {
      loading = true;
    });

    bool isValid = await widget.myAuth.verifyOTP(otp: otp);
    if (isValid) {
      print('OTP is valid');
      // Call the sign-up function or navigate to the next screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified Successfully")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompleteRegister(
            firebaseUser: widget.firebaseUser,
            userModel: widget.userModel,
          ),
        ),
      );
    } else {
      print('OTP is invalid');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP is Invalid")),
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white, // Change box color to white
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white, // Ensure the submitted color is white as well
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img2.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Email Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your Email without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onCompleted: (pin) => verifyOtp(pin),
                defaultPinTheme: defaultPinTheme, // Apply the default pin theme
                focusedPinTheme: focusedPinTheme, // Apply the focused pin theme
                submittedPinTheme:
                    submittedPinTheme, // Apply the submitted pin theme
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CompleteRegister(
                            firebaseUser: widget.firebaseUser,
                            userModel: widget.userModel,
                          ),
                        ),
                      );
                    },
                    child: loading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        : const Text("Verify Email",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
