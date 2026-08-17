import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

enum EstadoAuth { carregando, sucesso, erro }

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  EstadoAuth _estado = EstadoAuth.sucesso;
  String? _mensagemErro;

  EstadoAuth get estado => _estado;
  String? get mensagemErro => _mensagemErro;

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
  }) async {
    _estado = EstadoAuth.carregando;
    notifyListeners();

    try {
      await _service.cadastrar(nome: nome, email: email, senha: senha);
      _estado = EstadoAuth.sucesso;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _mensagemErro = _service.traduzirErro(e);
      _estado = EstadoAuth.erro;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({required String email, required String senha}) async {
    _estado = EstadoAuth.carregando;
    notifyListeners();

    try {
      await _service.login(email: email, senha: senha);
      _estado = EstadoAuth.sucesso;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _mensagemErro = _service.traduzirErro(e);
      _estado = EstadoAuth.erro;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
  }
}
