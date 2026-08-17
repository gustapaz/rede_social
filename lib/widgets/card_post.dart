import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/post_provider.dart';

class CardPost extends StatelessWidget {
  final Post post;
  final String usuarioAtualId;
  final VoidCallback? onComentar;

  const CardPost({
    super.key,
    required this.post,
    required this.usuarioAtualId,
    this.onComentar,
  });

  @override
  Widget build(BuildContext context) {
    final jaCurtiu = post.curtidoPor.contains(usuarioAtualId);
    final ehAutor = post.autorId == usuarioAtualId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    post.iniciaisAutor,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.autorNome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(post.criadoEm),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (ehAutor)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      context.read<PostProvider>().deletarPost(post.id);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(post.texto),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    jaCurtiu ? Icons.favorite : Icons.favorite_border,
                    color: jaCurtiu ? Colors.red : null,
                  ),
                  onPressed: () {
                    context.read<PostProvider>().alternarCurtida(
                      postId: post.id,
                      usuarioId: usuarioAtualId,
                      jaCurtiu: jaCurtiu,
                    );
                  },
                ),
                Text('${post.curtidoPor.length}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () => onComentar?.call(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
