import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/comentario.dart';
import '../services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _service = PostService();

  bool _publicando = false;
  bool get publicando => _publicando;

  Stream<List<Post>> get streamPosts => _service.streamPosts();

  Future<void> criarPost({
    required String autorId,
    required String autorNome,
    required String texto,
  }) async {
    _publicando = true;
    notifyListeners();

    try {
      await _service.criarPost(
        autorId: autorId,
        autorNome: autorNome,
        texto: texto,
      );
    } finally {
      _publicando = false;
      notifyListeners();
    }
  }

  Future<void> alternarCurtida({
    required String postId,
    required String usuarioId,
    required bool jaCurtiu,
  }) async {
    await _service.alternarCurtida(
      postId: postId,
      usuarioId: usuarioId,
      jaCurtiu: jaCurtiu,
    );
  }

  Future<void> deletarPost(String postId) async {
    await _service.deletarPost(postId);
  }

  Stream<List<Comentario>> streamComentarios(String postId) {
    return _service.streamComentarios(postId);
  }

  Future<void> adicionarComentario({
    required String postId,
    required String autorId,
    required String autorNome,
    required String texto,
  }) async {
    await _service.adicionarComentario(
      postId: postId,
      autorId: autorId,
      autorNome: autorNome,
      texto: texto,
    );
  }
}
