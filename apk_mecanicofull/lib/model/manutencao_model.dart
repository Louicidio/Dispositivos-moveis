import 'package:cloud_firestore/cloud_firestore.dart';

class Manutencao {
  String? id; 
  String userId; 
  String descricao;
  String tipoServico;
  String data;
  int quilometragem;
  double valor;
  String status;
  String mecanico;
  DateTime? createdAt; 
  DateTime? updatedAt; 

  Manutencao({
    this.id,
    required this.userId,
    required this.descricao,
    required this.tipoServico,
    required this.data,
    required this.quilometragem,
    required this.valor,
    required this.status,
    required this.mecanico,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'descricao': descricao,
      'tipoServico': tipoServico,
      'data': data,
      'quilometragem': quilometragem,
      'valor': valor,
      'status': status,
      'mecanico': mecanico,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory Manutencao.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Manutencao(
      id: doc.id,
      userId: data['userId'] ?? '',
      descricao: data['descricao'] ?? '',
      tipoServico: data['tipoServico'] ?? '',
      data: data['data'] ?? '',
      quilometragem: data['quilometragem'] ?? 0,
      valor: (data['valor'] ?? 0).toDouble(),
      status: data['status'] ?? '',
      mecanico: data['mecanico'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
