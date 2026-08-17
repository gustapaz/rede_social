# Rede Social

Aplicativo Flutter de rede social simples, com autenticação e feed de posts em tempo real usando Firebase.

## Funcionalidades

- Cadastro e login de usuários (email/senha) via Firebase Authentication
- Feed de posts em tempo real (Cloud Firestore)
- Criação de posts de texto
- Curtir / descurtir posts
- Comentários em posts
- Exclusão de posts

## Tecnologias

- [Flutter](https://flutter.dev/) / Dart
- [Firebase Core](https://pub.dev/packages/firebase_core)
- [Firebase Authentication](https://pub.dev/packages/firebase_auth)
- [Cloud Firestore](https://pub.dev/packages/cloud_firestore)
- [Provider](https://pub.dev/packages/provider) para gerenciamento de estado
- [intl](https://pub.dev/packages/intl) para formatação de datas

## Estrutura do projeto

```
lib/
├── main.dart                 # Ponto de entrada e configuração dos providers
├── firebase_options.dart     # Configuração do Firebase (gerado pelo FlutterFire CLI)
├── models/                   # Modelos de dados (Post, Usuario, Comentario)
├── providers/                # Gerenciamento de estado (AuthProvider, PostProvider)
├── services/                 # Integração com Firebase (AuthService, PostService)
├── screens/                  # Telas do app
│   ├── auth/                 # Login e cadastro
│   ├── feed/                 # Feed e comentários
│   └── tela_raiz.dart        # Controla navegação entre autenticado/não autenticado
└── widgets/                  # Componentes reutilizáveis (card de post, etc.)
```

## Como rodar

### Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado
- [Firebase CLI](https://firebase.google.com/docs/cli) e [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) instalados
- Um projeto Firebase configurado (Authentication com Email/Senha habilitado e Cloud Firestore)

> Os arquivos de configuração do Firebase (`lib/firebase_options.dart`, `android/app/google-services.json`, etc.) não são versionados neste repositório, pois contêm identificadores específicos do projeto Firebase. Cada desenvolvedor deve gerá-los localmente com os passos abaixo.

### Passos

1. Instale as dependências:

   ```bash
   flutter pub get
   ```

2. Configure o Firebase para o projeto (gera `lib/firebase_options.dart` e os arquivos nativos de configuração):

   ```bash
   flutterfire configure
   ```

3. Execute o app:

   ```bash
   flutter run
   ```

## Testes

```bash
flutter test
```
