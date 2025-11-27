class Manutencao {
  int? id;
  String descricao;
  String tipoServico;
  String data;
  int quilometragem;
  double valor;
  String status;
  String mecanico;

  Manutencao({
    this.id,
    required this.descricao,
    required this.tipoServico,
    required this.data,
    required this.quilometragem,
    required this.valor,
    required this.status,
    required this.mecanico,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'tipo_servico': tipoServico,
      'data': data,
      'quilometragem': quilometragem,
      'valor': valor,
      'status': status,
      'mecanico': mecanico,
    };
  }

  factory Manutencao.fromMap(Map<String, dynamic> map) {
    return Manutencao(
      id: map['id'],
      descricao: map['descricao'],
      tipoServico: map['tipo_servico'],
      data: map['data'],
      quilometragem: map['quilometragem'],
      valor: map['valor'],
      status: map['status'],
      mecanico: map['mecanico'],
    );
  }
}