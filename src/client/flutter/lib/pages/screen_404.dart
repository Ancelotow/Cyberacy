import 'package:flutter/material.dart';

class Screen404 extends StatelessWidget {
  const Screen404({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Text(
          "404 : Ooops... Page introuvable",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }

}
