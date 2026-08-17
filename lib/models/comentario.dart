import 'package:cloud_firestore/cloud_firestore.dart';

class Comentario {
  final String id;
  final String autorId;
  final String autorNome;
  final String texto;
  final DateTime criadoEm;

  Comentario({
    required this.id,
    required this.autorId,
    required this.autorNome,
    required this.texto,
    required this.criadoEm,
  });

  factory Comentario.fromFirestore(Map<String, dynamic> dados, String id) {
    return Comentario(
      id: id,
      autorId: dados['autorId'] ?? '',
      autorNome: dados['autorNome'] ?? '',
      texto: dados['texto'] ?? '',
      criadoEm: (dados['criadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'autorId': autorId,
      'autorNome': autorNome,
      'texto': texto,
      'criadoEm': FieldValue.serverTimestamp(),
    };
  }
}
