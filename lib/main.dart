import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:  AppBarTheme(
          backgroundColor: Colors.transparent,
          toolbarHeight: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,

          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String animationUrl;
  Artboard? _teddyArtboard;
  SMITrigger? successTrigger, failureTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? numberLook;

  StateMachineController? stateMachineController;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void initState() {
    animationUrl = "assets/2244-4437-animated-login-screen.riv";
    rootBundle.load(animationUrl).then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      stateMachineController = StateMachineController.fromArtboard(
        artboard,
        'Login Machine',
      );
      if (stateMachineController != null) {
        artboard.addController(stateMachineController!);
        stateMachineController!.inputs.forEach((e) {
          debugPrint(e.runtimeType.toString());
          debugPrint("name${e.name}End");
        });
        stateMachineController!.inputs.forEach((element) {
          if (element.name == "trigSuccess") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "trigFail") {
            failureTrigger = element as SMITrigger;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
          } else if (element.name == "isChecking") {
            isChecking = element as SMIBool;
          } else if (element.name == "numLook") {
            numberLook = element as SMINumber;
          }
        });
      }
      setState(() {
        _teddyArtboard = artboard;
      });
    });

    super.initState();
  }

  void handsOnTheEyes(){
    isHandsUp!.change(true);
  }

  void lookOnTheField(){
    isHandsUp!.change(false);
    isChecking!.change(true);
    numberLook!.change(0);
  }

  void moveEyeBalls(val){
    numberLook!.change(val.length.toDouble());
  }

  void login()async{
    await isChecking!.change(false);
    await isHandsUp!.change(false);
    if(_emailController.text == "heshamatef040@gmail.com" && _passController.text == "55555"){
      successTrigger!.fire();
    }else{
      failureTrigger!.fire();
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Color(0xffd6e2ea),
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: 300,
          width: 400,
          child: Rive(
            artboard: _teddyArtboard!,
            fit: BoxFit.fitWidth,
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: 400,
          padding: EdgeInsets.only(bottom: 15),
          margin: EdgeInsets.only(bottom: 15 * 4),
          decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              SizedBox(height: 15 * 2),

              //textfield for email
              PhysicalModel(
                elevation: 5,
                color: Color(0xffd6e2ea),
                borderRadius: BorderRadius.circular(25),
                child: TextField(
                  controller: _emailController,
                  onTap: lookOnTheField,
                  onChanged: moveEyeBalls,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  cursorColor: Color(0xffb04863),
                  decoration: InputDecoration(
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusColor: Color(0xffb04863),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Color(0xffb04863),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              //textfield for password
              PhysicalModel(
                elevation: 5,
                color: Color(0xffd6e2ea),
                borderRadius: BorderRadius.circular(25),
                child: TextField(
                  controller: _passController,
                  onTap: handsOnTheEyes,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  cursorColor: Color(0xffb04863),
                  decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusColor: Color(0xffb04863),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Color(0xffb04863),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: login,
                child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  backgroundColor: Color(0xffb04863),
                ),
              ),

              SizedBox(height: 50),

            ]),
          ),
        ),
      ])),
    );
  }
}
