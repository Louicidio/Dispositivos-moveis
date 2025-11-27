import 'package:flutter/material.dart';
import '../model/manutencao_model.dart';
import '../service/manutencao_service.dart';
import '../components/show_alert_data.dart';
import '../components/my_button.dart';
import 'manutencaoadd_page.dart';
import 'manutencaodetalhes_page.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _fabScale = 1.0;
  final ManutencaoService _service = ManutencaoService();

  Color getCorPorTipoServico(String statusServico) {
    switch (statusServico.toLowerCase()) {
      case 'em andamento':
        return Colors.orange.shade100;
      case 'concluído':
        return Colors.green.shade100;
      case 'aguard peças':
        return Colors.grey.shade100;
      case 'cancelado':
        return Colors.red.shade100;
      default:
        return Colors.blue;
    }
  }

  double getValorTotal(List<Manutencao> manutencoes) {
    return manutencoes.fold(0.0, (total, m) => total + m.valor);
  }

  Future<void> _deletarManutencao(String id) async {
    await _service.deletar(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manutenções',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Sair',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sair'),
                  content: const Text('Deseja realmente sair da conta?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Manutencao>>(
        stream: _service.listarTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final manutencoes = snapshot.data ?? [];
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(12),
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Manutenções: ${manutencoes.length}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Valor Total: R\$ ${getValorTotal(manutencoes).toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: manutencoes.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma manutenção cadastrada',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: manutencoes.length,
                        itemBuilder: (context, index) {
                          final manutencao = manutencoes[index];
                          return Dismissible(
                            key: Key(manutencao.id.toString()),
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 24),
                              color: Colors.green,
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar exclusão'),
                                    content: const Text(
                                      'Deseja realmente excluir esta manutenção?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                );
                                return confirm ?? false;
                              } else if (direction ==
                                  DismissDirection.startToEnd) {
                                if (manutencao.status != 'Concluído') {
                                  manutencao.status = 'Concluído';
                                  await _service.atualizar(manutencao);
                                  ShowAlertData.show(
                                    context,
                                    'Manutenção marcada como Concluído.',
                                  );
                                }
                                return false;
                              }
                              return false;
                            },
                            onDismissed: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                await _deletarManutencao(manutencao.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Manutenção excluída!'),
                                  ),
                                );
                              }
                            },
                            child: FadeInUp(
                              duration: Duration(
                                milliseconds: 400 + index * 100,
                              ),
                              child: Card(
                                color: getCorPorTipoServico(manutencao.status),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      Icons.car_repair,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    manutencao.tipoServico,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Valor: R\$${manutencao.valor.toStringAsFixed(2)}',
                                              ),
                                              Text(
                                                'Mecânico: ${manutencao.mecanico}',
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Status: ${manutencao.status}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text('Data: ${manutencao.data}'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetalhesManutencaoScreen(
                                              manutencao: manutencao,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: AnimatedScale(
        scale: _fabScale,
        duration: const Duration(milliseconds: 100),
        child: Padding(
          // gambiarra
          padding: const EdgeInsets.only(left: 150.0, bottom: 8.0, right: 8.0),
          child: SizedBox(
            height: 60,
            width: 240,
            child: MyButton(
              text: 'Nova Manutenção',
              textColor: Colors.black,
              prefixIcon: Icons.add,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdicionarManutencaoScreen(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
