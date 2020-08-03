import 'package:app_comunica_if/model/mensagem.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'ler_mensagem.dart';

Widget mensagemCard(
    BuildContext context, int index, List<Mensagem> listaTemporaria, Function atualizarTela) {
  return GestureDetector(
    onTap: () async {
      listaTemporaria[index].lida = true;

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LerMensagem(listaTemporaria[index])
          )
      );
      atualizarTela();
    },
    child: Card(

        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      listaTemporaria[index].lida ? Icons.drafts : Icons.email,
                      color: Cores.corIconesClaro,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: Text(
                          listaTemporaria[index].titulo,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Cores.corTextEscuro),
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        listaTemporaria[index].conteudo,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, color: Cores.corTextMedio),
                      )),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatarDataHora(listaTemporaria[index].dataHoraPublicacao),
                    ),
                  ),
                ),
              ],
            )),
      ),

  );
}

