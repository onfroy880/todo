import 'package:flutter/material.dart';
import 'package:todo/screen/menu/homescreen.dart';
import 'package:todo/service/offline.dart';
import 'package:todo/widget/layout/appbutton.dart';
import 'package:todo/widget/layout/apptitle.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  var optionLanguage = [
    'English',
    'French',
  ];
  late String currentSelectedValue = optionLanguage[0];

  List images = [
    'images/avatar1.png',
    'images/avatar2.png',
    'images/avatar4.png',
    'images/avatar3.png',
  ];
  int currentImage = 0;
  void onTap(int index) {
    setState(() {
      currentImage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.indigoAccent, Colors.lightBlue], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            AppTitle(text: 'Welcome to ToDo', color: Colors.white, isFont: true, size: 30,),
            Expanded(child: Container()),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: images.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            onTap(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            height: 65,
                            width: MediaQuery.of(context).size.width / 4 - 15,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 216, 213, 213),
                              border: Border.all(
                                width: 2,
                                color: images[index] ==
                                    images[currentImage]
                                    ? Colors.orange
                                    : Colors.white,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                )
                              ],
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(55)),
                              image: DecorationImage(
                                image: AssetImage('${images[index]}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: TextFormField(
                      controller: name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is not empty*';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                          fillColor: Colors.white70,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 234, 101, 101),
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: DropdownButtonFormField(
                      value: currentSelectedValue,
                      items: optionLanguage.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          currentSelectedValue = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                          fillColor: Colors.white70,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 234, 101, 101),
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await OfflineService.createUser(name.text, currentSelectedValue, images[currentImage]);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                      }
                    },
                    child: AppButtonResponsive(
                      widht: MediaQuery.of(context).size.width,
                      btnTxt: 'Get Start',
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}