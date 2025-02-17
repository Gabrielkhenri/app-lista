import 'package:flutter/material.dart';
import 'package:myapp/modelos/planetas.dart';
import 'package:myapp/telas/telas_planetas.dart';

import 'controles/controle_planeta.dart';
//import 'modelos/planetas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App-planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 169, 209, 24),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App-planetas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  List<Planeta> _planetas = [];
  // ignore: unused_field
  //final TelaPlaneta _telaPlaneta = TelaPlaneta(onFinalizado: () {});

  @override
  void initState() {
    super.initState();
    _lerPlanetas();
  }

  Future<void> _lerPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TelaPlaneta(
              isIncluir: true,
              planeta: Planeta.vazio(),
              onFinalizado: () {
                _atualizarPlanetas();
              },
            ),
      ),
    );
  }

  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TelaPlaneta(
              isIncluir: false,
              planeta: planeta,
              onFinalizado: () {
                _atualizarPlanetas();
              },
            ),
      ),
    );
  }

  void _excluirPlaneta(int id) async {
    await _controlePlaneta.excluirPlaneta(id);
    _lerPlanetas(); //
  }

  //main tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _planetas.length,
          itemBuilder: (context, index) {
            final planeta = _planetas[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  planeta.nome,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Distância: ${planeta.distancia.toString()} km',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _alterarPlaneta(context, planeta),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _excluirPlaneta(planeta.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirPlaneta(context);
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        tooltip: 'Adicionar Planeta',
        child: const Icon(Icons.add),
      ),
    );
  }
}
