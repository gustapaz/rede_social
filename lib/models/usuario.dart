class Usuario {
  final String id;
  final String nome;
  final String email;

  Usuario({required this.id, required this.nome, required this.email});

  factory Usuario.fromFirestore(Map<String, dynamic> dados, String id) {
    return Usuario(
      id: id,
      nome: dados['nome'] ?? '',
      email: dados['email'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'nome': nome, 'email': email};
  }

  String get iniciais {
    final partes = nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    } else if (partes.isNotEmpty && partes.first.isNotEmpty) {
      return partes.first[0].toUpperCase();
    }
    return '?';
  }
}
