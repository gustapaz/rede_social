import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String autorId;
  final String autorNome;
  final String texto;
  final DateTime criadoEm;
  final List<String> curtidoPor;

  Post({
    required this.id,
    required this.autorId,
    required this.autorNome,
    required this.texto,
    required this.criadoEm,
    required this.curtidoPor,
  });

  factory Post.fromFirestore(Map<String, dynamic> dados, String id) {
    return Post(
      id: id,
      autorId: dados['autorId'] ?? '',
      autorNome: dados['autorNome'] ?? '',
      texto: dados['texto'] ?? '',
      criadoEm: (dados['criadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
      curtidoPor: List<String>.from(dados['curtidoPor'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'autorId': autorId,
      'autorNome': autorNome,
      'texto': texto,
      'criadoEm': FieldValue.serverTimestamp(),
      'curtidoPor': curtidoPor,
    };
  }

  String get iniciaisAutor {
    final partes = autorNome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    } else if (partes.isNotEmpty && partes.first.isNotEmpty) {
      return partes.first[0].toUpperCase();
    }
    return '?';
  }
}
