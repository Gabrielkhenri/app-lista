import 'package:flutter/material.dart';
import 'package:myapp/controles/controle_planeta.dart';
//import 'package:myapp/modelos/planeta.dart';

import '../modelos/planetas.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final Function() onFinalizado;

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tamanhoController = TextEditingController();
  final _distanciaController = TextEditingController();
  final _apelidoController = TextEditingController();
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  final Planeta _planeta = Planeta.vazio();

  @override
  //metodos
  void initState() {
    super.initState();
    // _controlePlaneta.bd;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }
  //eniva form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dados do planeta foram ${widget.isIncluir ? 'incluidos' : 'alterados'} com sucesso!',
          ),
        ),
      );
      Navigator.of(context).pop();
      widget.onFinalizado();
    }
  }
  //TELA FORM
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastro de Planeta'),
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo para nome do planeta
                _buildTextField(
                  controller: _nameController,
                  label: 'Nome',
                  validator:
                      (value) =>
                          value == null || value.isEmpty || value.length < 3
                              ? 'Nome deve ter pelo menos 3 caracteres'
                              : null,
                  onSaved: (value) => _planeta.nome = value!,
                ),

                // Campo para tamanho do planeta
                _buildTextField(
                  controller: _tamanhoController,
                  label: 'Tamanho (em km)',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o tamanho do planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Tamanho inválido';
                    }
                    return null;
                  },
                  onSaved: (value) => _planeta.tamanho = double.parse(value!),
                ),

                // Campo para distância do planeta
                _buildTextField(
                  controller: _distanciaController,
                  label: 'Distância (em milhões de km)',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a distância';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Distância inválida';
                    }
                    return null;
                  },
                  onSaved: (value) => _planeta.distancia = double.parse(value!),
                ),

                // Campo para apelido
                _buildTextField(
                  controller: _apelidoController,
                  label: 'Apelido',
                  onSaved: (value) => _planeta.apelido = value,
                ),

                const SizedBox(height: 24.0),

                // Botões de cancelar e confirmar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton(
                      text: 'Cancelar',
                      onPressed: () => Navigator.of(context).pop(),
                      color: Colors.grey,
                    ),
                    _buildButton(
                      text: 'Confirmar',
                      onPressed: _submitForm,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Personalização
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.edit),
      ),
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onSaved: onSaved,
    );
  }

  // Método para criar botões personalizados
  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(text),
    );
  }
}
