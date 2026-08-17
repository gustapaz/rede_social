import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get statusAutenticacao => _auth.authStateChanges();

  User? get usuarioAtual => _auth.currentUser;

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );

    final novoUsuario = Usuario(
      id: credencial.user!.uid,
      nome: nome,
      email: email,
    );

    await _firestore
        .collection('usuarios')
        .doc(novoUsuario.id)
        .set(novoUsuario.toFirestore());
  }

  Future<void> login({required String email, required String senha}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: senha);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<Usuario?> buscarUsuario(String id) async {
    final doc = await _firestore.collection('usuarios').doc(id).get();
    if (!doc.exists) return null;
    return Usuario.fromFirestore(doc.data()!, doc.id);
  }

  String traduzirErro(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Esse email já está cadastrado.';
      case 'weak-password':
        return 'A senha precisa ter pelo menos 6 caracteres.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ou senha incorretos.';
      case 'invalid-email':
        return 'Email inválido.';
      default:
        return 'Erro ao autenticar. Tentar novamente.';
    }
  }
}
