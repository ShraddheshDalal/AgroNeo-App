// ignore_for_file: file_names, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeNameH = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String name = '';
  late String url = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          name = userDoc["firstName"] ?? '';
          url = userDoc["image"] ?? '';
        });
      }
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(245, 239, 255, 1),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello,',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(162, 148, 249, 1),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(162, 148, 249, 1),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '👋',
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromRGBO(162, 148, 249, 1),
                          width: 2,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile2');
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 24),
                const Text(
                  'Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(162, 148, 249, 1),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildMenuGrid(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(162, 148, 249, 1),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search services',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext contextt) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildMenuItem(
            'Market', Icons.store, Icons.shopping_cart, contextt, "/market2"),
        _buildMenuItem(
            'Chat-Bot', Icons.chat_bubble, Icons.smart_toy, contextt, '/chat-bot'),
        _buildMenuItem(
            'Schemes', Icons.account_balance, Icons.policy, contextt, '/schemes'),
        _buildMenuItem('Forcast', Icons.sunny, Icons.cloud, contextt, '/forcast'),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData mainIcon, IconData secondaryIcon,
      BuildContext context, String rroute) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, rroute);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(229, 217, 242, 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(mainIcon,
                      size: 32, color: const Color.fromRGBO(162, 148, 249, 1)),
                  const SizedBox(width: 8),
                  Icon(secondaryIcon,
                      size: 32, color: const Color.fromRGBO(162, 148, 249, 1)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(162, 148, 249, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}