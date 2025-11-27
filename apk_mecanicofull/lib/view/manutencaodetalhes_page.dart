import 'package:flutter/material.dart';
import '../model/manutencao_model.dart';
import 'manutencaoadd_page.dart';

class DetalhesManutencaoScreen extends StatefulWidget {
  final Manutencao manutencao;

  const DetalhesManutencaoScreen({super.key, required this.manutencao});

  @override
  State<DetalhesManutencaoScreen> createState() =>
      _DetalhesManutencaoScreenState();
}

class _DetalhesManutencaoScreenState extends State<DetalhesManutencaoScreen> {
  late Manutencao manutencao;

  @override
  void initState() {
    super.initState();
    manutencao = widget.manutencao;
  }

  Future<void> _editarManutencao() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdicionarManutencaoScreen(manutencao: manutencao),
      ),
    );
    if (resultado != null && resultado is Manutencao) {
      setState(() {
        manutencao = resultado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.black,
            onPressed: _editarManutencao,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetalhe('Tipo de Serviço', manutencao.tipoServico),
                const Divider(),
                _buildDetalhe('Data', manutencao.data),
                const Divider(),
                _buildDetalhe(
                  'Quilometragem',
                  '${manutencao.quilometragem} km',
                ),
                const Divider(),
                _buildDetalhe(
                  'Valor',
                  'R\$ ${manutencao.valor.toStringAsFixed(2)}',
                ),
                const Divider(),
                _buildDetalhe('Status', manutencao.status),
                const Divider(),
                _buildDetalhe('Mecânico', manutencao.mecanico),
                const Divider(),
                _buildDetalhe('Descrição', manutencao.descricao),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetalhe(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(valor, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
