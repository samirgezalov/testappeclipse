import 'package:flutter/material.dart';
import 'package:testappeclipse/model/user_model.dart';

class AdressView extends StatelessWidget {
  const AdressView({Key? key, this.adress}) : super(key: key);
  final Address? adress;
  /*
  Т.к тестовое задание делал по минимуму, чтобы обозначить пути реализации
  конечно по хорошему нужно создать форму, подогнать размеры, распределить поля,
   добавить мап превью и гиперссылку на координаты и т.д
   */

  @override
  Widget build(BuildContext context) {
    // var data = Provider.of<ProviderHelper>(context);
    if (adress == null) return Container();
    return Column(children: [
      const Text("Adress:"),
      Text(
        'street: ${adress!.street}, suite: ${adress!.suite}, city: ${adress!.city}, zipcode: ${adress!.zipcode}',
        softWrap: true,
      )
    ]);
  }
}
