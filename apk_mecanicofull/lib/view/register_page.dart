import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/my_card.dart';
import '../components/show_alert_data.dart';
import '../service/auth_service.dart';
import '../components/loading_dialog.dart';
import '../components/back_button.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ShowAlertData.show(context, 'Preencha todos os campos');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ShowAlertData.show(context, 'As senhas não conferem');
      return;
    }

    if (_passwordController.text.length < 6) {
      ShowAlertData.show(context, 'A senha deve ter pelo menos 6 caracteres');
      return;
    }
    if (!_passwordController.text.contains(RegExp(r'[A-Z]'))) {
      ShowAlertData.show(
        context,
        'A senha deve conter pelo menos uma letra maiúscula',
      );
      return;
    }

    LoadingDialog.show(context);

    try {
      await _authService.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      Navigator.pop(context);
      ShowAlertData.show(context, 'Conta criada com sucesso!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      LoadingDialog.hide(context);
      if (e.code == 'email-already-in-use') {
        ShowAlertData.show(context, 'Este email já está em uso');
      } else if (e.code == 'invalid-email') {
        ShowAlertData.show(context, 'Email inválido');
      } else {
        ShowAlertData.show(context, e.message ?? 'Erro ao criar conta');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.blueAccent,
          iconColor: Colors.white,
          size: 40,
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent, Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyCard(
                    title: 'Novo Cadastro',
                    subtitle: 'Preencha os dados abaixo',
                    children: [
                      MyTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        hintText: 'seu@email.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: _passwordController,
                        labelText: 'Senha',
                        hintText: '',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        showTogglePassword: true,
                        onTogglePassword: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirmar Senha',
                        hintText: '',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscureConfirmPassword,
                        showTogglePassword: true,
                        onTogglePassword: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      MyButton(text: 'Criar Conta', onPressed: _register),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Já tem uma conta? ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Faça login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
