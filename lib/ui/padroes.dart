import 'package:flutter/material.dart';

Widget titulo(String texto) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Text(texto,
          style: TextStyle(
            fontSize: 24
          ),
        ),
      )
    ],
  );
}

//padrão de label para inputs
Widget labelInputs(String texto) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(texto, style: estiloLabelInputs()),
        ),
      ],
    ),
  );
}

//estilo do label dos inputs
TextStyle estiloLabelInputs() {
  return TextStyle(fontSize: 24, color: Cores.corTextMedio);
}

//input para dados de texto
Widget inputLinhaSimples(String label, TextEditingController controller) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      Expanded(
        child: TextFormField(
          controller: controller,
          minLines: 1,
          maxLines: 10,
          decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Cores.corTextMedio),
              ),
              labelText: label, labelStyle: estiloLabelInputs()),
          validator: (value) {
            if(value.isEmpty) {
              return "Campo não pode estar vazio!";
            }
            return null;
          },
          onFieldSubmitted: (texto) {
            controller.text = texto;
          },
        ),
      ),
    ],
  );
}

//linha de texto expandida
Widget linhaTextoExpandida(String texto) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Text(texto),
      )
    ],
  );
}

String formatarDataHora(DateTime dataHora) {
  String dia = dataHora.day < 10 ? "0${dataHora.day}": "${dataHora.day}";
  String mes = dataHora.month < 10 ? "0${dataHora.month}" : "0${dataHora.month}";
  String ano = "${dataHora.year}";

  String hora = dataHora.hour < 10 ? "0${dataHora.hour}": "${dataHora.hour}";
  String minuto = dataHora.minute < 10 ? "0${dataHora.minute}": "${dataHora.minute}";

  return "$dia/$mes/$ano $hora:$minuto";
}


class Cores {

  //static const corAppBarBackground =  Color(0xFF17252A);
  static const corAppBarBackground =  Color(0xFF3AAFA9);

  static const corTextEscuro =  Color(0xFF17252A);
  static const corTextMedio =  Color(0xFF2B7A78);
  static const corTextClaro =  Color(0xFFFEFFFF);

  static const corPrimaria =  Color(0xFF17252A);
  static const corIconesClaro = Color(0xFF3AAFA9);

  static const corBotoes = Color(0xFF2B7A78);

  static const corFundo = Color(0xFF2B7A68);

  static const corFundoBottomBar = Color(0xFF3AAFA9);

  static const corPretoTransparente = Color(0xDD000000);

  static const cor3 = Color(0xFF2B7A78);
  static const cor4 = Color(0xFFDEF2F1);
  static const cor5 = Color(0xFFFEFFFF);

}