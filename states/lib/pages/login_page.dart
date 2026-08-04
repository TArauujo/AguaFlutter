import 'package:flutter/material.dart';
import '../pages/agua_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerSenha = TextEditingController();

  bool obscureSenha = true;

  // 🔥 DIALOG DE SUCESSO
  void mostrarSucesso() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Login efetuado com sucesso",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        );
      },
    );

    // 🔥 Fecha e navega
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AguaPage()),
      );
    });
  }

  void login() {
    String email = controllerEmail.text.trim();
    String senha = controllerSenha.text.trim();

    if (email == "admin" && senha == "123") {
      mostrarSucesso();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Inválido!!", textAlign: TextAlign.center),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 65, 73),

      appBar: AppBar(
        title: Text("Água.com.br"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "ÁGUA 👍💧",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('images/water.png', height: 120),

                        const SizedBox(height: 20),

                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        TextField(
                          controller: controllerEmail,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextField(
                          controller: controllerSenha,
                          obscureText: obscureSenha,
                          decoration: InputDecoration(
                            labelText: "Senha",
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureSenha
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureSenha = !obscureSenha;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.all(14),
                            ),
                            child: const Text("Entrar"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
