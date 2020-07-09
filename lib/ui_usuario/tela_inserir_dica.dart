

import 'dart:io';

import 'package:app_comunica_if/model/dica.dart';
import 'package:app_comunica_if/sistema/sistema_admin.dart';
import 'package:app_comunica_if/ui/padroes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Dica _dica;

bool _isImagemLocal;

class TelaInseirDica extends StatefulWidget {

  TelaInseirDica({Dica dica}) {
    if(dica == null) {
      _dica = Dica();
      _isImagemLocal = true;
      _dica.ativo = true;
    }
    else {
      _dica = Dica.fromMap(dica.toMap());
      _dica.id = dica.id;
      _isImagemLocal = false;
    }
  }

  @override
  _TelaInseirDicaState createState() => _TelaInseirDicaState();
}

class _TelaInseirDicaState extends State<TelaInseirDica> {


  bool _isEnviandoDica = false;

  final chaveScaffold = GlobalKey<ScaffoldState>();

  final picker = ImagePicker();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: chaveScaffold,
      appBar: AppBar(
        title: Text("Nova Dica"),
        backgroundColor: Cores.corAppBarBackground,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            inserirTextoDica(),
            tituloPrevia(),
            previaImagemDica(),
            previaTextoDica(),
            botaoPublicarDica(),
          ],
        ),
      ),
    );
  }

  Widget previaTextoDica() {
    return Container(
      //color: Cores.corFundo,
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Text(_dica.texto?? "Sem texto...",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20, fontFamily: 'Roboto')),
      )
    );
  }

  Widget previaImagemDica() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: imagemLocalOuRemota()
    );
  }

  Widget imagemLocalOuRemota() {
    if (_isImagemLocal) {
      if (_dica.imagem != null) {
        return  SizedBox(
            width: double.infinity,
            child: Image.file(
              _dica.imagem,
              fit: BoxFit.fitWidth,
          //TODO formatar imagem
            )
        );
      }
      else {
        return Text("Sem imagem...", style: TextStyle(fontSize: 20, fontFamily: 'Roboto'));
      }
    }
    else {
      return SizedBox(
          width: double.infinity,
          child: Image.network(_dica.caminhoImagem)
      );
    }
  }

  Widget swicthAtivo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text("Dica ativada", style: TextStyle(fontSize: 20),),
        Switch(
          activeColor: Cores.corIconesClaro,
            value: _dica.ativo,
            onChanged: (valor) {
              setState(() {
                _dica.ativo = valor;
              });
            }
        )
      ],
    );
  }

  Widget botaoInserirImagem() {
    return Padding(
        padding: EdgeInsets.all(10),
        child: RaisedButton.icon(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Cores.corBotoes)),
          color: Cores.corBotoes,
          label: Text(_dica.imagem == null ? "Inserir imagem" : "Alterar imagem", style: TextStyle(color: Colors.white)),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () async {
            _isImagemLocal = true;
            await getImage();
            }
        ));
  }

  Widget botaoPublicarDica() {
    return Visibility(
      visible: _dica.texto != null && (_dica.nomeImagem != null || _dica.imagem != null),
      child: Padding(
          padding: EdgeInsets.all(10),
          child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Cores.corBotoes)),
              color: Cores.corBotoes,
              label: Text(_dica.id == null ? "Publicar dica" : "Alterar dica", style: TextStyle(color: Colors.white)),
              icon: Icon(
                Icons.playlist_add,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () async {


                publicarDica();

                //await SistemaAdmin.instance.gravarDica(_dica);
                //Navigator.pop(context);
              }
          )),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _dica.imagem = File(pickedFile.path);
    });
  }


  Widget tituloPrevia() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Text("Prévia da dica", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }

  //card para inserção de parágrafos na notícia
  Widget inserirTextoDica() {
    TextEditingController paragrafoController = TextEditingController();
    return Card(
      child: Column(
        children: <Widget>[
          swicthAtivo(),
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Expanded(
                    child: inputLinhaSimples("Texto da dica", paragrafoController),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 40,
                      color: Cores.corBotoes,
                    ),
                    onPressed: () {
                      setState(() {
                        _dica.texto = paragrafoController.text;
                      });
                    },
                  )
                ],
              )),
          botaoInserirImagem()
        ],
      )
    );
  }


  publicarDica() {

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Publicar?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              linhaTextoExpandida("Deseja realmente publicar?"),
            ],
          ),
          actions: <Widget>[
            Visibility(
              visible: _isEnviandoDica,
              child: Center(child: CircularProgressIndicator()),
            ),
            Visibility(
                visible: !_isEnviandoDica,
                child: FlatButton(
                  child: Text("Não"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
            Visibility(
              visible: !_isEnviandoDica,
              child: FlatButton(
                  child: Text("Sim"),
                  onPressed: () async {
                    setState(() {
                      _isEnviandoDica = true;
                    });
                    await SistemaAdmin.instance.gravarDica(_dica);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            )
          ],
        ));
  }
}
