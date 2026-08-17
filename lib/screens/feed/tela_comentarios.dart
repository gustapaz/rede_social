import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/comentario.dart';
import '../../models/usuario.dart';
import '../../providers/post_provider.dart';

class TelaComentarios extends StatefulWidget {
  final String postId;
  final Usuario usuarioAtual;

  const TelaComentarios({
    super.key,
    required this.postId,
    required this.usuarioAtual,
  });

  @override
  State<TelaComentarios> createState() => _TelaComentariosState();
}

class _TelaComentariosState extends State<TelaComentarios> {
  final TextEditingController _controller = TextEditingController();
  late final Stream<List<Comentario>> _streamComentarios;

  @override
  void initState() {
    super.initState();
    _streamComentarios = context.read<PostProvider>().streamComentarios(
      widget.postId,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _enviarComentario() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    await context.read<PostProvider>().adicionarComentario(
      postId: widget.postId,
      autorId: widget.usuarioAtual.id,
      autorNome: widget.usuarioAtual.nome,
      texto: texto,
    );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Comentários',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: StreamBuilder<List<Comentario>>(
                stream: _streamComentarios,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final comentarios = snapshot.data ?? [];

                  if (comentarios.isEmpty) {
                    return const Center(
                      child: Text('Nenhum comentário ainda.'),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: comentarios.length,
                    itemBuilder: (context, index) {
                      final comentario = comentarios[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            comentario.autorNome.isNotEmpty
                                ? comentario.autorNome[0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(comentario.autorNome),
                        subtitle: Text(comentario.texto),
                        trailing: Text(
                          DateFormat('HH:mm').format(comentario.criadoEm),
                          style: const TextStyle(fontSize: 11),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 8,
                bottom: MediaQuery.of(context).viewInsets.bottom + 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Escreva um comentário...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _enviarComentario(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _enviarComentario,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
