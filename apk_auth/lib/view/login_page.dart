import 'package:apk_auth/view/components/my_button.dart';
import 'package:apk_auth/view/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Icon(Icons.lock, size: 100),
              SizedBox(height: 50),
              Text(
                'Seja Bem-vindo(a)',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25),
              MyTextfield(
                controller: usernameController,
                hintText: "Email",
                obscureText: false,
              ),
              SizedBox(height: 15),

              MyTextfield(
                controller: passwordController,
                hintText: "Senha",
                obscureText: true,
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              MyButton(onTap: signUserIn, text: "Entrar"),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Não possui cadastro?',
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Registorpage()));
                    },
                    child: Text("Registre-se agora",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
