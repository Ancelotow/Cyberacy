import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../models/dialog/alert_normal.dart';
import '../../models/errors/api_service_error.dart';
import '../../models/notifications/save_notification.dart';
import '../../models/services/manifestation_service.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/input_field/input_text.dart';

class FormAbortedManifestation extends StatelessWidget {
  final int idManifestation;
  final TextEditingController ctrlReason = TextEditingController();

  FormAbortedManifestation({
    Key? key,
    required this.idManifestation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 500;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputText(
              placeholder: "Raisons (facultatif)",
              icon: Icons.abc,
              width: width,
              controller: ctrlReason,
            ),
            const SizedBox(height: 10),
            Button(
              label: "Confimer l'annulation",
              width: width,
              isLoad: false,
              pressedColor: Colors.lightBlue,
              click: () => _abortedManifestation(context),
            ),
            const SizedBox(height: 10),
            Button(
              label: "Retour",
              width: width,
              color: Colors.red,
              pressedColor: Colors.redAccent,
              click: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _abortedManifestation(BuildContext context) async {
    try {
      await ManifService()
          .abortedManifestation(idManifestation, ctrlReason.text);
      SaveNotification(ctrlReason.text).dispatch(context);
      Navigator.of(context).pop();
    } on ApiServiceError catch (e) {
      AlertNormal(
        title: "Erreur lors de l'annulation",
        message: e.responseHttp.body,
        labelButton: "Continuer",
        context: context,
      ).show();
    }
  }
}
