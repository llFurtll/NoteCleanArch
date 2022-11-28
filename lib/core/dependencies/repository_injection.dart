import 'package:flutter/material.dart';

import '../../features/config_app/domain/repositories/iconfig_app_repository.dart';
import '../../features/config_user/domain/repositories/iconfig_user_repository.dart';
import '../../features/home/domain/repositories/ihome_repository.dart';
import '../../features/note/domain/repositories/inote_repository.dart';
import '../../features/atualizacao/domain/repositories/iatualizacao_repository.dart';
import '../../features/versao/domain/repositories/iversao_repository.dart';

class RepositoryInjection extends InheritedWidget {
  final IConfigAppRepository configAppRepository;
  final IConfigUserRepository configUserRepository;
  final IHomeRepository homeRepository;
  final INoteRepository noteRepository;
  final IAtualizacaoRepository atualizacaoRepository;
  final IVersaoRepository versaoRepository;
  final Widget child;

  const RepositoryInjection({
    Key? key,
    required this.configAppRepository,
    required this.configUserRepository,
    required this.homeRepository,
    required this.noteRepository,
    required this.atualizacaoRepository,
    required this.versaoRepository,
    required this.child
  }) : super(key: key, child: child);

  static RepositoryInjection? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<RepositoryInjection>());
  }

  @override
  bool updateShouldNotify(RepositoryInjection oldWidget) => false;
}