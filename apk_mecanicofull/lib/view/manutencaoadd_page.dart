// gigantesco devido a 300 validações 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/manutencao_model.dart';
import '../service/manutencao_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:brasil_fields/brasil_fields.dart';

class DateValidator {
  static bool isValidDate(String date) {
    if (date.isEmpty || date.length != 10) return false;

    try {
      final parts = date.split('/');
      if (parts.length != 3) return false;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      if (year < 1900 || year > 2100) return false;

      if (month < 1 || month > 12) return false;

      final daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

      if (month == 2 && _isLeapYear(year)) {
        daysInMonth[1] = 29;
      }

      if (day < 1 || day > daysInMonth[month - 1]) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  static bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  static String? validateDateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a data';
    }

    if (!isValidDate(value)) {
      return 'Data inválida. Use o formato dd/mm/aaaa';
    }

    return null;
  }
}

class AdicionarManutencaoScreen extends StatefulWidget {
  final Manutencao? manutencao;
  final maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  AdicionarManutencaoScreen({super.key, this.manutencao});

  @override
  State<AdicionarManutencaoScreen> createState() =>
      _AdicionarManutencaoScreenState();
}

class _AdicionarManutencaoScreenState extends State<AdicionarManutencaoScreen> {
  final _formKey = GlobalKey<FormState>();
  final ManutencaoService _service = ManutencaoService();

  late TextEditingController _descricaoController;
  late TextEditingController _tipoServicoController;
  late TextEditingController _dataController;
  late TextEditingController _quilometragemController;
  late TextEditingController _valorController;
  late TextEditingController _mecanicoController;

  String _statusSelecionado = 'Em andamento';
  final List<String> _statusOpcoes = [
    'Em andamento',
    'Concluído',
    'Aguard peças',
    'Cancelado',
  ];

  @override
  void initState() {
    super.initState();
    _descricaoController = TextEditingController(
      text: widget.manutencao?.descricao ?? '',
    );
    _tipoServicoController = TextEditingController(
      text: widget.manutencao?.tipoServico ?? '',
    );
    _dataController = TextEditingController(
      text: widget.manutencao?.data ?? '',
    );
    _quilometragemController = TextEditingController(
      text: widget.manutencao?.quilometragem.toString() ?? '',
    );
    _valorController = TextEditingController(
      text: widget.manutencao != null
          ? UtilBrasilFields.obterReal(widget.manutencao!.valor)
          : '',
    );
    _mecanicoController = TextEditingController(
      text: widget.manutencao?.mecanico ?? '',
    );
    _statusSelecionado = widget.manutencao?.status ?? 'Em andamento';
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _tipoServicoController.dispose();
    _dataController.dispose();
    _quilometragemController.dispose();
    _valorController.dispose();
    _mecanicoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      double valorFinal = UtilBrasilFields.converterMoedaParaDouble(
        _valorController.text,
      );
      final manutencao = Manutencao(
        id: widget.manutencao?.id,
        userId: FirebaseAuth.instance.currentUser!.uid,
        descricao: _descricaoController.text,
        tipoServico: _tipoServicoController.text,
        data: _dataController.text,
        quilometragem: int.parse(_quilometragemController.text),
        valor: valorFinal,
        status: _statusSelecionado,
        mecanico: _mecanicoController.text,
      );

      if (widget.manutencao == null) {
        await _service.inserir(manutencao);
      } else {
        await _service.atualizar(manutencao);
      }

      Navigator.pop(context, manutencao);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.manutencao == null ? 'Nova Manutenção' : 'Editar Manutenção',
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _tipoServicoController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Serviço',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o tipo de serviço';
                  }
                  if (value.length > 30) {
                    return 'Tipo de serviço muito longo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dataController,
                decoration: const InputDecoration(
                  labelText: 'Data (dd/mm/aaaa)',
                  border: OutlineInputBorder(),
                  hintText: '01/01/2024',
                  hintStyle: TextStyle(color: Colors.black38),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [widget.maskFormatter],
                validator: DateValidator.validateDateField,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quilometragemController,
                decoration: const InputDecoration(
                  labelText: 'Quilometragem',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quilometragem';
                  }
                  final km = int.tryParse(value);
                  if (km == null || km <= 0 || km > 2000000) {
                    return 'Numero de quilometragem muito invalido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  hintText: 'R\$ 0,00',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(moeda: true),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  double valor = UtilBrasilFields.converterMoedaParaDouble(value);
                  if (valor <= 0 || valor > 100000) {
                    return 'Por favor, insira um valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _statusSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: _statusOpcoes.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _statusSelecionado = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mecanicoController,
                decoration: const InputDecoration(
                  labelText: 'Mecânico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do mecânico';
                  }
                  if (value.length < 3) {
                    return 'Nome do mecânico muito curto';
                  }
                  if (value.length > 12) { // não aguento mais verificação
                    return 'Nome do mecânico muito longo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLength: 350,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  if (value.length < 5) {
                    return 'A descrição deve conter no minimo 5 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Salvar', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
