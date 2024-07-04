
import 'package:flutter/material.dart';

import '../models/motivation_modell.dart';
import '../services/motivation_auth_services.dart';
class MotivationController extends ChangeNotifier {
  final _motivHttpService = MotivationHttpServices();

  Future<List<MotivationModel>> getMotiv(String quote) async {
    List<MotivationModel> motivation = await _motivHttpService.fetchQuoteData(quote);
    return motivation;
  }
}