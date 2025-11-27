import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/manutencao_model.dart';

class ManutencaoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  CollectionReference get _collection =>
      _firestore.collection('users').doc(_userId).collection('manutencoes');

  Future<void> inserir(Manutencao manutencao) async {
    manutencao.userId = _userId;
    await _collection.add(manutencao.toMap());
  }

  Stream<List<Manutencao>> listarTodos() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Manutencao.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> atualizar(Manutencao manutencao) async {
    if (manutencao.id == null) throw Exception('ID não pode ser nulo');
    await _collection.doc(manutencao.id).update(manutencao.toMap());
  }

  Future<void> deletar(String id) async {
    await _collection.doc(id).delete();
  }
}
