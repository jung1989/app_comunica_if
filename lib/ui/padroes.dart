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
  return TextStyle(fontSize: 24);
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
              labelText: label, labelStyle: estiloLabelInputs()),
          validator: (value) {
            if(value.isEmpty) {
              return "Campo não pode estar vazio!";
            }
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
