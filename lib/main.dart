import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const SynapseApp());
}
