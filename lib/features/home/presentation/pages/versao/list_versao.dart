import 'package:flutter/material.dart';

import '../../../../../core/dependencies/repository_injection.dart';
import '../../../../../core/notifiers/change_notifier_global.dart';
import '../../../../../core/widgets/show_loading.dart';
import '../../../../../core/widgets/show_message.dart';
import '../../../../atualizacao/domain/entities/atualizacao.dart';
import '../../../../atualizacao/domain/usecases/atualizacao_usecase.dart';
import '../../../../atualizacao/presentation/arguments/arguments_info_atualizacao.dart';
import '../../../../atualizacao/presentation/principal/info_atualizacao.dart';
import '../../../../versao/domain/entities/versao.dart';
import '../../../../versao/domain/usecases/versao_use_case.dart';

class ListaVersao extends StatefulWidget {
  static final String routeListaVersao = "/versao";

  @override
  ListaVersaoState createState() => ListaVersaoState();
}

class ListaVersaoState extends State<ListaVersao> {
  final List<Versao> versoes = [];
  final ChangeNotifierGlobal<bool> isLoading = ChangeNotifierGlobal(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadVersions();
      isLoading.value = false;
    });
  }

  Future<void> _loadVersions() async {
    final getVersoes = VersaoUseCase(RepositoryInjection.of(context)!.versaoRepository);
    final result = await getVersoes.findAll();
    versoes.addAll(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (BuildContext context, bool value, Widget? widget) {
          if (isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return Container(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: versoes.map((item) => _buildItem(item)).toList(),
            ),
          );
        },
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      child: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Versões do EasyNote"),
        automaticallyImplyLeading: false,
        leading: _buildBack(),
      ),
      preferredSize: Size.fromHeight(56.0)
    );
  }

  Widget _buildBack() {
    return IconButton(
      tooltip: "Voltar",
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(Icons.arrow_back_ios),
    );
  }

  Widget _buildItem(Versao versao) {
    return ListTile(
      onTap: () async {
        showLoading(context);
        final useCase = AtualizacaoUsecase(RepositoryInjection.of(context)!.atualizacaoRepository);
        List<Atualizacao> items = await useCase.findAllByVersao(versao.idVersao!);
        Navigator.of(context).pop();
        ArgumentsInfoAtualizacao arguments = ArgumentsInfoAtualizacao(start: false, list: items);
        if (items.isNotEmpty) {
          Navigator.pushNamed(context, InfoAtualizacao.routeInfoAtualizacao, arguments: arguments);
        } else {
          showMessage(context, "Falha ao carregar a versão, tente novamente!");
        }
      },
      title: Text(
        "Versão ${versao.versao}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_sharp),
      subtitle: Text("Clique para saber mais!"),
    );
  }
}