import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../entities/consumo.dart';
import 'login_page.dart';

class AguaPage extends StatefulWidget {
  const AguaPage({super.key});

  @override
  State<AguaPage> createState() => _AguaPageState();
}

class _AguaPageState extends State<AguaPage> {
  List<DiaConsumo> dias = [
    DiaConsumo(dia: "Segunda-feira", meta: 2000),
    DiaConsumo(dia: "Terça-feira", meta: 3000),
    DiaConsumo(dia: "Quarta-feira", meta: 2650),
    DiaConsumo(dia: "Quinta-feira", meta: 2000),
    DiaConsumo(dia: "Sexta-feira", meta: 3000),
    DiaConsumo(dia: "Sábado", meta: 2650),
    DiaConsumo(dia: "Domingo", meta: 2000),
  ];

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void mostrarMetaAtingida(String dia) {
    _confettiController.play();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.2,
              ),
            ),
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.orange,
                    size: 70,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Parabéns! 🎉\nMeta de $dia atingida",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void beber(int index) {
    setState(() {
      dias[index].consumido += 200;

      if (dias[index].consumido >= dias[index].meta &&
          !dias[index].metaAtingida) {
        dias[index].metaAtingida = true; // 👈 marca como já mostrado
        mostrarMetaAtingida(dias[index].dia);
      }
    });
  }

  void remover(int index) {
    if (dias[index].consumido > 0) {
      setState(() {
        dias[index].consumido -= 200;
      });
    }
  }

  double progresso(DiaConsumo dia) {
    return (dia.consumido / dia.meta).clamp(0, 1);
  }

  void logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Você está prestes a realizar logout",
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "Tem certeza que deseja sair?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text("Sair", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),

      appBar: AppBar(
        title: const Text("Bebendo Água 💧"),
        centerTitle: true,
        backgroundColor: const Color(0xFF00ACC1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: logout,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: dias.length,
          itemBuilder: (context, index) {
            var dia = dias[index];
            bool concluido = dia.consumido >= dia.meta;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: ListTile(
                title: Text(
                  dia.dia,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${dia.consumido} / ${dia.meta} ml"),

                    const SizedBox(height: 6),

                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progresso(dia)),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 8,
                          color: concluido ? Colors.green : Colors.blue,
                          backgroundColor: Colors.grey[300],
                        );
                      },
                    ),

                    if (dia.metaAtingida) ...[
                      const SizedBox(height: 6),
                      const Text(
                        "Sua meta foi atingida!! 🎉",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),

                leading: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: concluido
                      ? const Icon(
                          Icons.check_circle,
                          key: ValueKey("ok"),
                          color: Colors.green,
                          size: 30,
                        )
                      : const Icon(
                          Icons.water_drop,
                          key: ValueKey("agua"),
                          color: Colors.blue,
                        ),
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: dia.consumido == 0
                          ? null
                          : () => remover(index),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    IconButton(
                      onPressed: () => beber(index),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
