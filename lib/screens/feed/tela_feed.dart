import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../models/usuario.dart';
import '../../models/post.dart';
import '../../providers/post_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/card_post.dart';
import 'tela_comentarios.dart';

class TelaFeed extends StatefulWidget {
  const TelaFeed({super.key});

  @override
  State<TelaFeed> createState() => _TelaFeedState();
}

class _TelaFeedState extends State<TelaFeed> {
  final TextEditingController _textoController = TextEditingController();
  late final Stream<List<Post>> _streamPosts;
  final AuthService _authService = AuthService();
  Usuario? _usuarioAtual;

  @override
  void initState() {
    super.initState();
    _streamPosts = context.read<PostProvider>().streamPosts;
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final usuario = await _authService.buscarUsuario(uid);
    if (mounted) {
      setState(() {
        _usuarioAtual = usuario;
      });
    }
  }

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }

  Future<void> _publicar() async {
    final texto = _textoController.text.trim();
    if (texto.isEmpty || _usuarioAtual == null) return;

    await context.read<PostProvider>().criarPost(
      autorId: _usuarioAtual!.id,
      autorNome: _usuarioAtual!.nome,
      texto: texto,
    );

    _textoController.clear();
  }

  void _abrirComentarios(String postId) {
    if (_usuarioAtual == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          TelaComentarios(postId: postId, usuarioAtual: _usuarioAtual!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioAtual = FirebaseAuth.instance.currentUser!;
    final publicando = context.watch<PostProvider>().publicando;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textoController,
                    decoration: const InputDecoration(
                      hintText: 'O que você está pensando?',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: publicando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  onPressed: publicando ? null : _publicar,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<Post>>(
              stream: _streamPosts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final posts = snapshot.data ?? [];

                if (posts.isEmpty) {
                  return const Center(
                    child: Text('Nenhum post ainda. Seja o primeiro!'),
                  );
                }

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return CardPost(
                      post: posts[index],
                      usuarioAtualId: usuarioAtual.uid,
                      onComentar: () => _abrirComentarios(posts[index].id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
