import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIU FRESH',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //scaffold provides the basic visual structure  of the screen, including the app bar, body, drawer, and floating action button
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💧', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 20),
            const Text(
              'KIU FRESH',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your Water Refilling Station',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                //defines what happens when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Get Started',
              ), //the widget displayed inside the button
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //controller for the phone or email input field
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey =
      GlobalKey<
        FormState
      >(); //a key that gives us access to this form, allowing us to trigger validation.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'KIU Fresh',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Login to your account', style: TextStyle(fontSize: 18)),
                SizedBox(height: 30),
                TextFormField(
                  //forms enable grouping of multiple input fields and validating them together
                  //creating an instance of the TextFormField class and passing arguements to its constructor
                  //creates an input field for the user to enter their phone number or email
                  controller: //controllers allow our dart code to read and manipulate  the text entered into the input fields.
                      emailController, //tells the text field to use this controller to manage the text entered by the user.
                  decoration: InputDecoration(
                    //controls the appearance of the input field
                    labelText:
                        'Phone or Email', //gives a label to the input field
                    border:
                        OutlineInputBorder(), //gives the input field an outlined border
                  ),
                  validator: (value) {
                    //validates the input field and return an error message if the value is empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number or email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText:
                      true, //hides the characters entered by the user, useful for password fields.
                  controller:
                      passwordController, //tells the text field to use this controller to manage the text entered by the user.
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    //validates the input field and return an error message if the value is empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    //what happens when the login button is pressed.
                    if (_formKey.currentState!.validate()) {
                      //checks if the form is valid
                      print(
                        'Email: ${emailController.text}, \nPassword: ${passwordController.text}',
                      );
                    }
                  },
                  child: Text('Login'), //what appears on the button
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
