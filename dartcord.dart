// DartCord - Programação para Dispositivos Móveis | UNISAPIENS

class Usuario {
  final String nome;
  final String apelido;
  bool online;

  Usuario({
    required this.nome,
    required this.apelido,
    this.online = false,
  });
}

class Mensagem {
  final Usuario autor;
  final String texto;
  final DateTime enviadaEm;

  Mensagem({
    required this.autor,
    required this.texto,
  }) : enviadaEm = DateTime.now();

  @override
  String toString() => '${autor.apelido}: $texto';
}

class Canal {
  final String nome;
  final List<Mensagem> _mensagens = [];

  Canal({required this.nome});

  List<Mensagem> get mensagens => List.unmodifiable(_mensagens);

  void adicionarMensagem(Mensagem mensagem) {
    _mensagens.add(mensagem);
  }

  void exibirMensagens() {
    print('#$nome');
    if (_mensagens.isEmpty) {
      print('(nenhuma mensagem)');
      return;
    }
    for (final m in _mensagens) {
      print(m);
    }
  }
}

class Servidor {
  final String nome;
  final List<Usuario> _usuarios = [];
  final List<Canal> _canais = [];

  Servidor({required this.nome});

  void adicionarUsuario(Usuario usuario) => _usuarios.add(usuario);

  void adicionarCanal(Canal canal) => _canais.add(canal);

  List<Usuario> get usuariosOnline =>
      _usuarios.where((u) => u.online).toList();

  Canal? buscarCanal(String nome) {
    for (final c in _canais) {
      if (c.nome == nome) return c;
    }
    return null;
  }

  void emitirRelatorio({required String canalExibido}) {
    print('DARTCORD');
    print('Servidor: $nome');
    print('');

    print('Usuários online:');
    for (final u in usuariosOnline) {
      print(u.apelido);
    }
    print('');

    print('Canais:');
    for (final c in _canais) {
      print('#${c.nome}');
    }
    print('');

    print('Exibindo mensagens do canal:');
    final canal = buscarCanal(canalExibido);
    if (canal == null) {
      print('Canal #$canalExibido não encontrado.');
    } else {
      canal.exibirMensagens();
    }
  }
}

void main() {
  // Objetos principais
  final usuario = Usuario(
    nome: 'Pedro',
    apelido: 'PG',
    online: true,
  );

  final ana = Usuario(
    nome: 'Ana',
    apelido: 'Ana',
    online: true,
  );

  final carlos = Usuario(
    nome: 'Carlos',
    apelido: 'Cadu',
    online: false, // offline: não aparece no relatório
  );

  final geral = Canal(nome: 'geral');
  final canal = Canal(nome: 'dart');
  final flutter = Canal(nome: 'flutter');

  // Conectando mensagens ao canal
  final mensagem = Mensagem(
    autor: usuario,
    texto: 'Olá, DartCord!',
  );
  canal.adicionarMensagem(mensagem);

  canal.adicionarMensagem(
    Mensagem(autor: ana, texto: 'Continuem praticando.'),
  );

  // Montando o servidor
  final servidor = Servidor(nome: 'Programação Mobile');
  servidor.adicionarUsuario(usuario);
  servidor.adicionarUsuario(ana);
  servidor.adicionarUsuario(carlos);

  servidor.adicionarCanal(geral);
  servidor.adicionarCanal(canal);
  servidor.adicionarCanal(flutter);

  // Relatório
  servidor.emitirRelatorio(canalExibido: 'dart');
}
