import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

void sendWhatsAppToAllUsers() async {
  final snapshot = await FirebaseFirestore.instance.collection('users').get();

  for (var doc in snapshot.docs) {
    final data = doc.data();
    final phone = data['phoneNumber'].toString();
    final name = data['firstName'] + ' ' + (data['lastName'] ?? '');
    final message = Uri.encodeComponent("Good morning $name! This is your daily message.");

    final url = "https://wa.me/91$phone?text=$message"; // assumes +91

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      await Future.delayed(Duration(seconds: 2));
    } else {
      print("Could not launch WhatsApp for $phone");
    }
  }
}
