import 'package:flutter/material.dart';
import '../../../controller/motivation_controller.dart';
import '../../../services/local_notification.dart';

class MotivationScreen extends StatefulWidget {
  const MotivationScreen({super.key});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final _motivationController = MotivationController();

  @override
  void initState() {
    super.initState();
    LocalNotificationsServices.start();
    _scheduleMotivationNotification();
    _scheduleDailyMotivationNotification();
  }

  void _scheduleMotivationNotification() async {
    while (true) {
      await LocalNotificationsServices.showNotificationTest(
          "Assalomu aalaykum!",
          "Sizning Umraga sayohat vizangiz chiqdi tabriklaymiz.");

      await Future.delayed(const Duration(minutes: 20));
    }
  }

  void _scheduleDailyMotivationNotification() async {
    final motivations = await _motivationController.getMotiv("happiness");
    if (motivations.isNotEmpty) {
      final motivation = motivations[0];
      await LocalNotificationsServices.scheduleDailyMotivationNotification(
          motivation.author, motivation.quote);
    }
    // await LocalNotificationsServices.scheduleDailyMotivationNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1f1b2e),
      body: SafeArea(
        child: FutureBuilder(
          future: _motivationController.getMotiv("happiness"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("Malumotlar mavjud emas"),
              );
            }
            final motivations = snapshot.data;
            final motivation = motivations![0];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    motivation.author,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    motivation.quote,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () async {
                final motivations =
                await _motivationController.getMotiv("happiness");
                if (motivations.isNotEmpty) {
                  final motivation = motivations[0];
                  await LocalNotificationsServices.showNotificationTest(
                      motivation.author, motivation.quote);
                }
              },
              child: const Text("Get the motiv"),
            ),
          ],
        ),
      ),
    );
  }
}