import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post.dart';
import '../models/comentario.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Post>> streamPosts() {
    return _firestore
        .collection('posts')
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Post.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> criarPost({
    required String autorId,
    required String autorNome,
    required String texto,
  }) async {
    final novoPost = Post(
      id: '',
      autorId: autorId,
      autorNome: autorNome,
      texto: texto,
      criadoEm: DateTime.now(),
      curtidoPor: [],
    );

    await _firestore.collection('posts').add(novoPost.toFirestore());
  }

  Future<void> alternarCurtida({
    required String postId,
    required String usuarioId,
    required bool jaCurtiu,
  }) async {
    final docRef = _firestore.collection('posts').doc(postId);

    if (jaCurtiu) {
      await docRef.update({
        'curtidoPor': FieldValue.arrayRemove([usuarioId]),
      });
    } else {
      await docRef.update({
        'curtidoPor': FieldValue.arrayUnion([usuarioId]),
      });
    }
  }

  Future<void> deletarPost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  Stream<List<Comentario>> streamComentarios(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comentarios')
        .orderBy('criadoEm')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Comentario.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> adicionarComentario({
    required String postId,
    required String autorId,
    required String autorNome,
    required String texto,
  }) async {
    final comentario = Comentario(
      id: '',
      autorId: autorId,
      autorNome: autorNome,
      texto: texto,
      criadoEm: DateTime.now(),
    );

    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comentarios')
        .add(comentario.toFirestore());
  }
}
